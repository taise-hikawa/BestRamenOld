import UIKit
import Firebase
//import FirebaseUI
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let authResult = authResult {
                //最初のログインか判定
                let isFirstLogin = authResult.additionalUserInfo!.isNewUser 
                if isFirstLogin{
                    //最初のログインの処理
                    let db = Firestore.firestore()
                    db.collection("users").document((authResult.user.uid)).setData([
                        "userName":authResult.user.displayName ?? "名無し"
                        
                    ]) { error in
                        if let error = error {
                            print(error)
                            return
                        }
                        // 成功したときの処理
                    }
                    //デフォルト画像を設定
                    let storageref = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com").child("users").child("\((authResult.user.uid)).jpg")
                    //画像
                    let image = UIImage(named: "default")
                    //imageをNSDataに変換
                    let data = image!.jpegData(compressionQuality: 1.0)
                    //メタデータを設定
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    //Storageに保存
                    storageref.putData(data!, metadata: metaData) { (data, error) in
                        if error != nil {
                            return
                        }
                    }
                }else{
                    //最初のログインでない時の処理
                    
                }
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
//      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//        return true
//      }
//      // other URL handling goes here.
//      return false
//    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

}

