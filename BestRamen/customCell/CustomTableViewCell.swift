//
//  CustomCellTableViewCell.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/05.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    
    
    
}
