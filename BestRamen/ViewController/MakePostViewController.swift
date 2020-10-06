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

class MakePostViewController: UIViewController,FloatingPanelControllerDelegate,RamenChooseViewControllerDelegate{
    
    
    
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
    @IBOutlet weak var postContentField: UITextField!
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // セミモーダルビューを非表示にする
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
    }
    
    @objc func shopChooseButtonTapped(_ sender:UIButton){
        let ramenChooseViewController = self.storyboard?.instantiateViewController(withIdentifier: "fpc2") as? RamenChooseViewController
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
        floatingPanelController = FloatingPanelController()
        ramenChooseViewController?.delegate = self
        floatingPanelController.set(contentViewController: ramenChooseViewController)
        floatingPanelController.delegate = self
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
        
    }
    func ramenChooseDidFinished(shopName: String, shopId: String, rank: Int) {
        self.shopId = shopId
        self.shopName = shopName
        shopChooseButton.setTitle(shopName, for: .normal)
        postFlag["shop"] = true
        floatingPanelController.removePanelFromParent(animated: true)
    }
    @IBAction func fieldEditingChange(_ sender: Any) {
        if postContentField.text == ""{
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
            "postContent":postContentField.text!
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
    //tipの位置になったらモーダルを終了
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition == .tip{
            vc.removePanelFromParent(animated: true)
        }
    }
}
