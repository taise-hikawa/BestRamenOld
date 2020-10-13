//
//  MakePostViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/10/05.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import FloatingPanel
import Firebase

class MakePostViewController: UIViewController,FloatingPanelControllerDelegate,RamenChooseViewControllerDelegate,UITextViewDelegate{
    
    
    
    
    var captureImage:UIImage!
    var floatingPanelController: FloatingPanelController!
    var shopId:String!
    var shopName:String!
    var postButton: UIBarButtonItem!
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var currentUser:User!
    var postFlag:Dictionary<String,Bool> = ["shop":false,"content":false]{
        didSet{
            if postButton == nil{return}
            if postFlag.values.contains(false){
                postButton.isEnabled = false
            }else{
                postButton.isEnabled = true
            }
        }
    }

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var shopChooseButton: UIButton!
    @IBOutlet weak var postContentTextView: UITextView!{
        didSet{
            postContentTextView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        postImage.image = captureImage
        print(postImage.image?.size as Any)
        shopChooseButton.addTarget(self, action: #selector(self.shopChooseButtonTapped(_:)), for: .touchUpInside)
        postButton = UIBarButtonItem(title: "投稿", style: .done, target: self, action: #selector(self.postButtonTapped(_:)))
        postButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = postButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // セミモーダルビューを非表示にする
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
        self.removeObserver() // Notificationを画面が消えるときに削除
        
    }
    
    @objc func shopChooseButtonTapped(_ sender:UIButton){
        if (postContentTextView.isFirstResponder) {
            postContentTextView.resignFirstResponder()
        }
        let ramenChooseViewController = self.storyboard?.instantiateViewController(withIdentifier: "fpc2") as? RamenChooseViewController
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
        floatingPanelController = FloatingPanelController()
        ramenChooseViewController?.delegate = self
        floatingPanelController.set(contentViewController: ramenChooseViewController)
        floatingPanelController.delegate = self
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self)
        
    }
    func ramenChooseDidFinished(shopName: String, shopId: String, rank: Int) {
        self.shopId = shopId
        self.shopName = shopName
        shopChooseButton.setTitle(shopName, for: .normal)
        postFlag["shop"] = true
        floatingPanelController.removePanelFromParent(animated: true)
    }
    func textViewDidChange(_ textView: UITextView) {
            let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if text?.isEmpty == true{
                postFlag["content"] = false
            }else{
                postFlag["content"] = true
            }
        }
    @objc func postButtonTapped(_ sender:UIButton){
        var ref: DocumentReference?
        ref = db.collection("posts").addDocument(data: [
            "userId": currentUser.uid,
            "userName": currentUser.displayName!,
            "shopId": shopId!,
            "shopName":shopName!,
            "postContent":(postContentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
            "createdAt": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added!")
                
                let storageref = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com").child("posts").child("\(ref?.documentID ?? "").jpg")
                //画像
                let image = self.captureImage
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
                //現在のタブはtabNavigatinoControllerのトップへ
                self.navigationController?.popToRootViewController(animated: true)
                //画面を一番左のtabへ遷移
                let UINavigationController = self.tabBarController?.viewControllers?[0]
                self.tabBarController?.selectedViewController = UINavigationController
            }
        }
    }
    // カスタマイズしたレイアウトに変更
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
    //tipの位置になったらモーダルを終了
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == FloatingPanelState.tip{
            fpc.removePanelFromParent(animated: true, completion: nil)
        }
    }
    private var activeTextView: UITextView? = nil
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        return true
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (postContentTextView.isFirstResponder) {
            postContentTextView.resignFirstResponder()
        }
    }
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        print("show")
        guard let userInfo = notification?.userInfo,
              let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboard.cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        // textViewの座標を全体座標に変換
//        let textframeParent = activeTextView!.convert(activeTextView!.frame, to: self.view)
        let txtLimit = (activeTextView?.frame.origin.y)! + (activeTextView?.frame.height)! + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        let moveY = txtLimit - kbdLimit
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if moveY >= 0{
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(moveY))
                self.view.transform = transform
                
            })
        }
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        print("hide")
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}
