import UIKit
import FirebaseStorage
import FirebaseFirestore

class UserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private let space:CGFloat = 1
    var userId:String!
    var userImgRef:StorageReference!
    var followDic:Dictionary<String, Any> = [:]
    var followAry:[Dictionary<String,Any>] = []
    var followerDic:Dictionary<String, Any> = [:]
    var followerAry:[Dictionary<String,Any>] = []
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var followNum = 0
    var followerNum = 0
    var postDic:Dictionary<String, Any> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followerListButton: UIButton!
    @IBOutlet weak var followListButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        userImageView.sd_setImage(with: userImgRef)
        followListButton.setTitle(String(followNum), for: .normal)
        followerListButton.setTitle(String(followerNum), for: .normal)
        setFollow()
        setFollower()
        setPosts()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set collectionView height to content size height.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewConstraintHeight.constant = layout.collectionViewContentSize.height
            view.layoutIfNeeded()
            view.frame.size.height = layout.collectionViewContentSize.height
        }
        // Set tableView height to content size height.
        tableView.layoutIfNeeded()
        tableViewConstraintHeight.constant = tableView.contentSize.height
        view.frame.size.height = tableView.contentSize.height
    }
    func setFollow(){
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            self.db.collection("relationships").whereField("follower", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents{
                        self.followDic["userDocumentId"] = document["followed"]
                        self.followAry.append(self.followDic)
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            for (index,dictionary) in self.followAry.enumerated(){
                self.db.collection("users").document(dictionary["userDocumentId"] as! String).getDocument(){(document,error2) in
                    if let document = document{
                        self.followAry[index]["userName"] = document["name"]
                        self.followNum = self.followAry.count
                        self.followListButton.setTitle(String(self.followNum), for: .normal)
                    }
                }
            }
        }
        
    }
    
    func setFollower(){
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            self.db.collection("relationships").whereField("followed", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                     for document in querySnapshot.documents{
                         self.followerDic["userDocumentId"] = document["follower"]
                         self.followerAry.append(self.followerDic)
                     }
                 }
                 dispatchGroup.leave()
             }
         }
         dispatchGroup.notify(queue: .main) {
             for (index,dictionary) in self.followerAry.enumerated(){
                self.db.collection("users").document(dictionary["userDocumentId"] as! String).getDocument(){(document,error2) in
                    if let document = document{
                        self.followerAry[index]["userName"] = document["name"]
                        self.followerNum = self.followerAry.count
                        self.followerListButton.setTitle(String(self.followerNum), for: .normal)
                    }
                }
             }
         }
        
    }
    func setPosts(){
        let dispatchGroup = DispatchGroup()
        let dispatchGroup2 = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            db.collection("posts").whereField("user", isEqualTo: userId!).getDocuments(){(querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents{
                        self.postDic["postId"] = document.documentID
                        self.postsAry.append(self.postDic)
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            for (index,dictionary) in self.postsAry.enumerated(){
                dispatchGroup2.enter()
                dispatchQueue.sync{
                    self.db.collection("posts").document(dictionary["postId"] as! String).getDocument{(document, error2) in
                        if let document = document{
                            self.postsAry[index]["postText"] = document.data()?["text"] as? String
                            self.postsAry[index]["shop"] = document.data()?["shop"] as? String
                        }
                        dispatchGroup2.leave()
                    }
                }
                dispatchGroup2.notify(queue: .main){
                    self.db.collection("shops").document(self.postsAry[index]["shop"] as! String).getDocument(){(document2,error3) in
                        if let document2 = document2{
                            self.postsAry[index]["shopName"] = document2.data()?["name"]
                            print(self.postsAry)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = UIColor.red
        let postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["postId"]!)).jpg")
        let postimageView = UIImageView()
        postimageView.sd_setImage(with: postImgRef)
        let cellSize:CGFloat = (self.view.bounds.width - (space * 2))/3
        cell.imageView.image = postimageView.image?.resized(toWidth: cellSize)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のスペース調整
        let cellSize:CGFloat = (self.view.bounds.width - (space * 2))/3
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    func buildUrl(url: StorageReference,width: CGFloat,height: CGFloat) -> StorageReference{
        
        return url.child("w=\(width)&h=\(height)")
        
    }
    
}
extension UIImage{
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
