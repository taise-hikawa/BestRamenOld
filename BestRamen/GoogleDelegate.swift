//
//  GoogleDelegate.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    static let shared = GoogleDelegate()
    @Published var signedIn: Bool = false
    
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
        signedIn = true
    }
}
