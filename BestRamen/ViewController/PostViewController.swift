import UIKit
import FirebaseStorage

class PostViewController: UIViewController {
    
    var postImgRef:StorageReference!
    var userImgRef:StorageReference!
    var shopName:String!
    var shopId:String!
    var userName:String!
    var postContent:String!
    var userId:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        postImage.image = UIImage(named: postImageName)
        postImage.sd_setImage(with: postImgRef)
        userButton.setTitle(userName, for: .normal)
        shopButton.setTitle(shopName, for: .normal)
        postLabel.text = postContent
        self.shopButton.addTarget(self,action: #selector(self.tapShopButton(_ :)),for: .touchUpInside)
        self.userButton.addTarget(self,action: #selector(self.tapUserButton(_ :)),for: .touchUpInside)
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
}
