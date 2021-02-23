//
//  FollowListViewController.swift
//  BestRamen
//
//  Created by Taisei Hikawa on 2020/09/23.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import Firebase

class FollowListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var userAry:[Dictionary<String,String>] = []
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FollowListTableViewCell", bundle: nil), forCellReuseIdentifier: "followListCell")
        //空の行の線を消す
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followListCell", for: indexPath) as! FollowListTableViewCell
        cell.userNameLabel.text = userAry[indexPath.row]["userName"]
        //firebaseの容量が超えたのでコメントアウト
//        self.storage.child("users").child("\(String(describing: userAry[indexPath.row]["userId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//            if error != nil {
//                return
//            }
//            if let imageData = data {
//                let userImg = UIImage(data: imageData)
//                cell.userImageView.image = userImg
//            }
//        }
        //firebaseの容量が超えたのでデフォルトの画像を表示
        cell.userImageView.image = UIImage(named: userAry[indexPath.row]["userId"] ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "toUserPageViewController", sender: nil)

    }
    //cellの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CGFloat(50)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserPageViewController" {
            let nextVC = segue.destination as! UserPageViewController
            let row = self.tableView.indexPathForSelectedRow?.row
            nextVC.userId = userAry[row!]["userId"]
            nextVC.fromSegue = true
        }
    }
    
    

}
