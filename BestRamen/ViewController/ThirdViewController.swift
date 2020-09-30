import UIKit
import FirebaseUI

class ThirdViewController: UIViewController ,FUIAuthDelegate{
    @IBOutlet weak var authButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
//        FUIFacebookAuth(),
//        FUIEmailAuth()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
            // authUIのデリゲート
            self.authUI.delegate = self
            self.authUI.providers = providers
            authButton.addTarget(self,action: #selector(self.authButtonTapped(sender:)),for: .touchUpInside)
        if Auth.auth().currentUser != nil {
//            print(Auth.auth().currentUser)
        } else {
          // No user is signed in.
          // ...
        }
    }
    
    @objc func authButtonTapped(sender : AnyObject) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }


}
