import UIKit
import Firebase

class ShopPageViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var shopId:String!
    var shopName:String!
    var postDic:Dictionary<String, Any> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    let space:CGFloat = 1
    var collectionSelectedNum:Int?

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAdressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopNameLabel.text = shopName
        setPosts()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
    }
    
    func setPosts(){
        let dispatchGroup = DispatchGroup()
        let dispatchGroup2 = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            db.collection("posts").whereField("shop", isEqualTo: shopId!).getDocuments(){(querySnapshot, error) in
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
                            self.postsAry[index]["user"] = document.data()?["user"] as? String
                        }
                        dispatchGroup2.leave()
                    }
                }
                dispatchGroup2.notify(queue: .main){
                    self.db.collection("users").document(self.postsAry[index]["user"] as! String).getDocument(){(document2,error3) in
                        if let document2 = document2{
                            self.postsAry[index]["userName"] = document2.data()?["name"]
                            self.postsAry[index]["userId"] = document2.documentID
                            print(self.postsAry)
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostViewController" {
            let nextVC = segue.destination as! PostViewController
            nextVC.shopName = shopName
            nextVC.userName = postsAry[collectionSelectedNum!]["userName"] as? String
            nextVC.postText = postsAry[collectionSelectedNum!]["postText"] as? String
            nextVC.shopId = shopId
            nextVC.postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[collectionSelectedNum!]["postId"]!)).jpg")
            nextVC.userImgRef = self.storage.child("users").child("\(String(describing: postsAry[collectionSelectedNum!]["userId"]!)).jpg")
            nextVC.userId = postsAry[collectionSelectedNum!]["userId"] as? String
        }
    }
}
