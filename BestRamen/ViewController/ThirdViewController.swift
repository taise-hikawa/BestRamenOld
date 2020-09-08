//
//  ThirdViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/04.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
