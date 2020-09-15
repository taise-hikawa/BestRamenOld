//
//  PostViewController.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/07.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostViewController: UIViewController {
    
    var postImgRef:StorageReference!
    var shopName:String!
    var userName:String!
    var postText:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        postImage.image = UIImage(named: postImageName)
        postImage.sd_setImage(with: postImgRef)
        userButton.setTitle(userName, for: .normal)
        shopButton.setTitle(shopName, for: .normal)
        postLabel.text = postText
        
    }
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var postLabel: UILabel!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
