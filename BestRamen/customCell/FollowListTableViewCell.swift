//
//  FollowListTableViewCell.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/23.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class FollowListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
