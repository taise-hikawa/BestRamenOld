import UIKit
import Firebase

class ShopPageViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var shopId:String!
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
        setPosts()
        setShop()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
    }
    func setShop(){
        db.collection("shops").document(shopId).getDocument{(document,error) in
            if let document = document{
                self.shopNameLabel.text = document.data()?["shopName"] as? String
                self.shopAdressLabel.text = "住所:\(document.data()?["shopAdress"] ?? "未登録")"
            }
        }
    }
    
    func setPosts(){
        db.collection("posts").whereField("shopId", isEqualTo: shopId!).getDocuments(){(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    self.postDic["userName"] = document.data()["userName"] as? String
                    self.postDic["userId"] = document.data()["userId"] as? String
                    self.postDic["shopName"] = document.data()["shopName"] as? String
                    self.postDic["postContent"] = document.data()["postContent"] as? String
                    self.postDic["postId"] = document.documentID
                    self.postsAry.append(self.postDic)
                    self.collectionView.reloadData()
                }
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! CustomCollectionViewCell
        storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["postId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let postImage = UIImage(data: imageData)!
                let cellSize:CGFloat = (self.view.bounds.width - (self.space * 2))/3
                cell.imageView.image = postImage.resized(toWidth: cellSize)
            }
        }
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
            nextVC.userId = postsAry[collectionSelectedNum!]["userId"] as? String
            nextVC.userName = postsAry[collectionSelectedNum!]["userName"] as? String
            nextVC.shopId = shopId
            nextVC.shopName = postsAry[collectionSelectedNum!]["shopName"] as? String
            nextVC.postContent = postsAry[collectionSelectedNum!]["postContetn"] as? String
            nextVC.postId = postsAry[collectionSelectedNum!]["postId"] as? String
        }
    }
}
