import UIKit
import FirebaseStorage

class PostViewController: UIViewController {
    
    var shopName:String!
    var shopId:String!
    var userName:String!
    var postContent:String!
    var userId:String!
    var postId:String!
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        userButton.setTitle(userName, for: .normal)
        shopButton.setTitle(shopName, for: .normal)
        postLabel.text = postContent
        self.shopButton.addTarget(self,action: #selector(self.tapShopButton(_ :)),for: .touchUpInside)
        self.userButton.addTarget(self,action: #selector(self.tapUserButton(_ :)),for: .touchUpInside)
        storage.child("users").child("\(userId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let userImg = UIImage(data: imageData)
                self.userImage.image = userImg
            }
        }
        storage.child("posts").child("\(postId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let postImg = UIImage(data: imageData)
                self.postImage.image = postImg
            }
        }
    }
    
    @objc func tapShopButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "toShopPage", sender: nil)
    }
    @objc func tapUserButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "toUserPage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toUserPage" {
            // 2. 遷移先のViewControllerを取得
            let nextVC = segue.destination as! UserPageViewController
            // 3. １で用意した遷移先の変数に値を渡す
            nextVC.userId = userId
            nextVC.fromSegue = true
            
        }
        if segue.identifier == "toShopPage"{
            let nextVC = segue.destination as! ShopPageViewController
            nextVC.shopId = shopId
            
        }
    }
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
}
