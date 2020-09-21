//
//  FirstViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/04.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let db = Firestore.firestore()
    let postsColRef = Firestore.firestore().collection("posts")
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var postDic:Dictionary<String, Any> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        setArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    func setArray(){
        let dispatchGroup = DispatchGroup()
        let dispatchGroup2 = DispatchGroup()
        // 直列キュー / attibutes指定なし
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            self.postsColRef.getDocuments{(querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents{
                        self.postDic["user"] = document.data()["user"] as? String
                        self.postDic["shop"] = document.data()["shop"] as? String
                        self.postDic["text"] = document.data()["text"] as? String
                        self.postDic["documentID"] = document.documentID
                        self.postsAry.append(self.postDic)
                        //                    self.postsAry[index] = self.postDic
                    }
                }
                dispatchGroup.leave()
            }
            
        }
        dispatchGroup.notify(queue: .main) {
            for (index,dictionary) in self.postsAry.enumerated(){
                dispatchGroup2.enter()
                dispatchQueue.async{
                    self.db.collection("shops").document(dictionary["shop"] as! String).getDocument{(document2,error2) in
                        if let document2 = document2{
                            self.postsAry[index]["shopName"] = document2.data()?["name"] as? String
                        }
                        dispatchGroup2.leave()
                    }
                }
                dispatchGroup2.enter()
                dispatchQueue.sync{
                    self.db.collection("users").document(dictionary["user"] as! String).getDocument{(document3,error3) in
                        if let document3 = document3{
                            self.postsAry[index]["userName"] = document3.data()?["name"] as? String
                            self.postsAry[index]["userDocumentID"] = document3.documentID
                        }
                        dispatchGroup2.leave()
                    }
                }
            }
            dispatchGroup2.notify(queue: .main){
                self.homeTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        let postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["documentID"]!)).jpg")
        cell.postImageView.sd_setImage(with: postImgRef)
        let userImgRef = self.storage.child("users").child("\(String(describing: postsAry[indexPath.row]["userDocumentID"]!)).jpg")
        print(userImgRef)
        cell.userImageView.sd_setImage(with: userImgRef)
        cell.userName.text = postsAry[indexPath.row]["userName"] as? String
        cell.shopName.text = postsAry[indexPath.row]["shopName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // 別の画面に遷移
        performSegue(withIdentifier: "toNextViewController", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            let nextVC = segue.destination as! PostViewController
            let row = self.homeTableView.indexPathForSelectedRow?.row
            nextVC.userName = postsAry[row!]["userName"] as? String
            nextVC.shopName = postsAry[row!]["shopName"] as? String
            nextVC.postText = postsAry[row!]["text"] as? String
            nextVC.userId = postsAry[row!]["userDocumentID"] as? String
            nextVC.postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[row!]["documentID"]!)).jpg")
            nextVC.userImgRef = self.storage.child("users").child("\(String(describing: postsAry[row!]["userDocumentID"]!)).jpg")
        }
    }
    

    @IBOutlet weak var homeTableView: UITableView!
    


}

