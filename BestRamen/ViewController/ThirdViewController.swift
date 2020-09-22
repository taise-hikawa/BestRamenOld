import UIKit
import FirebaseUI

class ThirdViewController: UIViewController ,FUIAuthDelegate{
    @IBOutlet weak var authButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    // 認証に使用するプロバイダの選択
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        FUIEmailAuth()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
            // authUIのデリゲート
            self.authUI.delegate = self
            self.authUI.providers = providers
            authButton.addTarget(self,action: #selector(self.authButtonTapped(sender:)),for: .touchUpInside)


    }
    
    @objc func authButtonTapped(sender : AnyObject) {
        // FirebaseUIのViewの取得
        let authViewController = self.authUI.authViewController()
        // FirebaseUIのViewの表示
        self.present(authViewController, animated: true, completion: nil)
    }

    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.performSegue(withIdentifier: "myPage", sender: nil)
        } else {
        //失敗した場合
            print("error")
        }
    }
}
