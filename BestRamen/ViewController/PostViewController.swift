//
//  PostViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/07.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var postImageName:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postImage.image = UIImage(named: postImageName)
    }
    @IBOutlet weak var postImage: UIImageView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
