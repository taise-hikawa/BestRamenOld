//
//  FirstViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/04.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var ref: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
        ref = Database.database().reference()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
//        cell.postImage.image = UIImage(named: "a")
        ref.child("posts").observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as? Dictionary<String, AnyObject>
//            cell.postText.text = (data?["post1"]?["text"]) as! String
//            cell.postText.text = "a"
        })
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
            nextVC.postImageName = "a"
        }
    }
    
    
    @IBOutlet weak var homeTableView: UITableView!
    


}

