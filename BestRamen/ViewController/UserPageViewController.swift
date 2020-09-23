import UIKit
import FirebaseStorage
import FirebaseFirestore

class UserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let space:CGFloat = 1
    var userId:String!
    var collectionSelectedNum:Int?
    var followDic:Dictionary<String, String> = [:]
    var followAry:[Dictionary<String,String>] = []
    var followerDic:Dictionary<String, String> = [:]
    var followerAry:[Dictionary<String,String>] = []
    var userAry:[Dictionary<String,String>] = []
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
        followListButton.setTitle("フォロー\n\(String(followNum))", for: .normal)
        //ボタンのテキストが改行可能に
        followListButton.titleLabel?.numberOfLines = 2
        //ボタンのテキスト中央寄せ
        followListButton.titleLabel!.textAlignment = NSTextAlignment.center
        followerListButton.setTitle("フォロワー\n\(String(followerNum))", for: .normal)
        followerListButton.titleLabel?.numberOfLines = 2
        followerListButton.titleLabel!.textAlignment = NSTextAlignment.center
        tableView.isScrollEnabled = false
        
        self.followListButton.addTarget(self,action: #selector(self.tapFollowListButton(_ :)),for: .touchUpInside)
        self.followerListButton.addTarget(self,action: #selector(self.tapFollowerListButton(_ :)),for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        postDic = [:]
        postsAry = []
        followDic = [:]
        followAry = []
        followerDic = [:]
        followerAry = []
        let userImgRef = storage.child("users").child("\(String(describing: userId!)).jpg")
        userImageView.sd_setImage(with: userImgRef)
        setFollow()
        setFollower()
        setPosts()
        setUser()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //collectionViewの高さを調整
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewConstraintHeight.constant = layout.collectionViewContentSize.height
            view.layoutIfNeeded()
        }
        //tableViewの高さを調整
        tableView.layoutIfNeeded()
        tableViewConstraintHeight.constant = tableView.contentSize.height
    }
    func setFollow(){
        self.db.collection("relationships").whereField("followerId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    self.followDic["userId"] = document["followedId"] as? String
                    self.followDic["userName"] = document["followedName"] as? String
                    self.followAry.append(self.followDic)
                    self.followNum = self.followAry.count
                    self.followListButton.setTitle("フォロー\n\(String(self.followNum))", for: .normal)
                }
            }
        }
    }
    
    func setFollower(){
        self.db.collection("relationships").whereField("followedId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    self.followerDic["userId"] = document["followerId"] as? String
                    self.followerDic["userName"] = document["followerName"] as? String
                    self.followerAry.append(self.followerDic)
                    self.followerNum = self.followerAry.count
                    self.followerListButton.setTitle("フォロワー\n\(String(self.followerNum))", for: .normal)
                }
            }
        }
    }
    
    func setUser(){
        self.db.collection("users").document(userId).getDocument{(document,error) in
            if let document = document{
//                document.data()["userName"] as? String
                self.profileLabel.text = document.data()?["userProfile"] as? String
            }
        }
    }
    
    func setPosts(){
        db.collection("posts").whereField("userId", isEqualTo: userId!).getDocuments(){(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    self.postDic["userName"] = document.data()["userName"] as? String
                    self.postDic["userId"] = document.data()["userId"] as? String
                    self.postDic["shopName"] = document.data()["shopName"] as? String
                    self.postDic["shopId"] = document.data()["shopId"] as? String
                    self.postDic["postContent"] = document.data()["postContent"] as? String
                    self.postDic["postId"] = document.documentID
                    self.postsAry.append(self.postDic)
                    self.collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionSelectedNum = indexPath.row
        performSegue(withIdentifier: "toPostViewController", sender: nil)
    }
    
    
    @objc func tapFollowListButton(_ sender: UIButton){
        userAry = followAry
        print("tap:\(followAry.count)")
        print("tap:\(userAry.count)")
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    @objc func tapFollowerListButton(_ sender: UIButton){
        
        userAry = followerAry
        print("tap:\(followerAry.count)")
        print("tap:\(userAry.count)")
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostViewController" {
            let nextVC = segue.destination as! PostViewController
            nextVC.userName = postsAry[collectionSelectedNum!]["userName"] as? String
            nextVC.userId = userId
            nextVC.shopName = postsAry[collectionSelectedNum!]["shopName"] as? String
            nextVC.shopId = postsAry[collectionSelectedNum!]["shopId"] as? String
            nextVC.postContent = postsAry[collectionSelectedNum!]["postContent"] as? String
            nextVC.postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[collectionSelectedNum!]["postId"]!)).jpg")
            nextVC.userImgRef = self.storage.child("users").child("\(String(describing: postsAry[collectionSelectedNum!]["userId"]!)).jpg")
        }
        else if segue.identifier == "toFollowListViewController"{
            let nextVC = segue.destination as! FollowListViewController
            nextVC.userAry = userAry
            print("prepare:\(userAry.count)")
        }
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
