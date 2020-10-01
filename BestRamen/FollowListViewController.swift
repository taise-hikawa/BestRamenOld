//
//  FollowListViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/23.
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
        print(userAry.count)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FollowListTableViewCell", bundle: nil), forCellReuseIdentifier: "followListCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followListCell", for: indexPath) as! FollowListTableViewCell
        cell.userNameLabel.text = userAry[indexPath.row]["userName"]
        let userImgRef = storage.child("users").child("\(String(describing: userAry[indexPath.row]["userId"]!)).jpg")
        cell.userImageView.sd_setImage(with: userImgRef)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "toUserPageViewController", sender: nil)

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
