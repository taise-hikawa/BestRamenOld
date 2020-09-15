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
    
    let postsColRef = Firestore.firestore().collection("posts")
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var postDic:Dictionary<String, Any> = [:]
    //    var postDic2:Dictionary<String, String> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        setArray2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    func setArray2(){
        let dispatchGroup = DispatchGroup()
        let dispatchGroup2 = DispatchGroup()
        // 直列キュー / attibutes指定なし
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.sync{
            self.postsColRef.getDocuments{(querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    for document in querySnapshot.documents{
                        print(document.data())
                        self.postDic["userRef"] = document.data()["user"] as? DocumentReference
                        self.postDic["shopRef"] = document.data()["shop"] as? DocumentReference
                        self.postDic["text"] = document.data()["text"] as? String
                        self.postDic["documentID"] = document.documentID
                        self.postsAry.append(self.postDic)
                        //                    self.postsAry[index] = self.postDic
                    }
                    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
                    print(self.postsAry)
                }
                print(1)
                dispatchGroup.leave()
            }
            
        }
        dispatchGroup.notify(queue: .main) {
            print("a")
            for (index,dictionary) in self.postsAry.enumerated(){
                let shopDecRef = dictionary["shopRef"] as? DocumentReference
                let userDecRef = dictionary["userRef"] as? DocumentReference
                dispatchGroup2.enter()
                dispatchQueue.async{
                    shopDecRef?.getDocument{(document2,error2) in
                        if let document2 = document2{
                            self.postsAry[index]["shopName"] = document2.data()?["name"] as? String
                        }
                        print(2)
                        print(self.postsAry)
                        dispatchGroup2.leave()
                    }
                }
                dispatchGroup2.enter()
                dispatchQueue.sync{
                    userDecRef?.getDocument{(document3,error3) in
                        if let document3 = document3{
                            self.postsAry[index]["userName"] = document3.data()?["name"] as? String
                            self.postsAry[index]["userDocumentID"] = document3.documentID
                        }
                        print(3)
                        print(self.postsAry)
                        dispatchGroup2.leave()
                    }
                }
            }
            dispatchGroup2.notify(queue: .main){
                self.homeTableView.reloadData()
                print("complete")
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
        cell.userImageView.sd_setImage(with: userImgRef)
        cell.userName.text = postsAry[indexPath.row]["userName"] as? String
        cell.shopName.text = postsAry[indexPath.row]["shopName"] as? String
        print(postsAry[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        hidesBottomBarWhenPushed = true

        // 別の画面に遷移
        performSegue(withIdentifier: "toNextViewController", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            let nextVC = segue.destination as! PostViewController
            let row = self.homeTableView.indexPathForSelectedRow?.row
            
            print(row!)
            nextVC.userName = postsAry[row!]["userName"] as? String
            nextVC.shopName = postsAry[row!]["shopName"] as? String
            nextVC.postText = postsAry[row!]["text"] as? String
            nextVC.postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[row!]["documentID"]!)).jpg")
        }
    }
    

    @IBOutlet weak var homeTableView: UITableView!
    


}

