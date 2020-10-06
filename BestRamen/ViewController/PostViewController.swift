import UIKit
import FirebaseStorage
import Firebase

class PostViewController: UIViewController {
    
    var shopName:String!
    var shopId:String!
    var userName:String!
    var postContent:String!
    var userId:String!
    var postId:String!
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var deleteButton: UIBarButtonItem!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = Auth.auth().currentUser
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
        deleteButton = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(deleteButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = deleteButton
        deleteButton.isEnabled = false
        deleteButton.tintColor = UIColor.clear
        if userId == currentUser?.uid{
            deleteButton.isEnabled = true
            deleteButton.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    @objc func tapShopButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "toShopPage", sender: nil)
    }
    @objc func tapUserButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "toUserPage", sender: nil)
    }
    //投稿を削除する
    @objc func deleteButtonTapped(_ sender: UIButton){
        //Firestoreのドキュメントを削除
        db.collection("posts").document(postId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        //Storageの画像ファイルを削除
        storage.child("posts").child("\(postId ?? "").jpg").delete { error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error removing file: \(error)")
            } else {
                // File deleted successfully
                print("File successfully removed!")
            }
        }
        //現在のタブはtabNavigatinoControllerのトップへ
        self.navigationController?.popToRootViewController(animated: true)
        //画面を一番右のtab(マイページ)へ遷移
        let UINavigationController = self.tabBarController?.viewControllers?[2]
        self.tabBarController?.selectedViewController = UINavigationController
        
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
