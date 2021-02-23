import UIKit
import FirebaseStorage
import Firebase

class PostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var item: Post?
    
    var deleteButton: UIBarButtonItem!
    let viewModel: PostViewModel? = PostViewModel()
    
    func initSelf(item: Post) {
        self.item = item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userButton.setTitle(item?.userName, for: .normal)
        shopButton.setTitle(item?.shopName, for: .normal)
        postLabel.text = item?.postContent
        postImage.contentMode = .scaleAspectFill
        self.shopButton.addTarget(self,action: #selector(self.tapShopButton(_ :)),for: .touchUpInside)
        self.userButton.addTarget(self,action: #selector(self.tapUserButton(_ :)),for: .touchUpInside)
        //firebaseの使用容量を超えたのでコメントアウト
//        storage.child("users").child("\(userId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//            if error != nil {
//                return
//            }
//            if let imageData = data {
//                let userImg = UIImage(data: imageData)
//                self.userImage.image = userImg
//            }
//        }
        self.userImage.image = UIImage(named: item?.userId?.description ?? "default")
//        storage.child("posts").child("\(postId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//            if error != nil {
//                return
//            }
//            if let imageData = data {
//                let postImg = UIImage(data: imageData)
//                self.postImage.image = postImg
//            }
//        }
        self.postImage.image = UIImage(named: item?.postId?.description ?? "a")
        deleteButton = UIBarButtonItem(title: "削除", style: .done, target: self, action: #selector(deleteButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = deleteButton
        deleteButton.isEnabled = false
        deleteButton.tintColor = UIColor.clear
        if item?.userId == viewModel?.currentUser {
            deleteButton.isEnabled = true
            deleteButton.tintColor = .white
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
        deleteButton.isEnabled = false
        
//            //Storageの画像ファイルを削除
//            self.storage.child("posts").child("\(self.postId ?? "").jpg").delete { error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
//                    print("Error removing file: \(error)")
//                } else {
//                    // File deleted successfully
//                    print("File successfully removed!")
//                }
//                dispatchGroup.leave()
//            }
//        }
        guard let id = item?.postId else { return }
        viewModel?.deletePost(id: id)
        //TODO: deleteが行われた後以下の処理をしないといけない
            //現在のタブはtabNavigatinoControllerのトップへ
            self.navigationController?.popToRootViewController(animated: true)
            //画面を一番右のtab(マイページ)へ遷移
            let UINavigationController = self.tabBarController?.viewControllers?[2]
            self.tabBarController?.selectedViewController = UINavigationController
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // segueのIDを確認して特定のsegueのときのみ動作させる
//        if segue.identifier == "toUserPage" {
//            // 2. 遷移先のViewControllerを取得
//            let nextVC = segue.destination as! UserPageViewController
//            // 3. １で用意した遷移先の変数に値を渡す
//            nextVC.userId = item["userId"]
//            nextVC.fromSegue = true
//
//        }
//        if segue.identifier == "toShopPage"{
//            let nextVC = segue.destination as! ShopPageViewController
//            nextVC.shopId = item["shopId"]
//
//        }
    }
    
}
