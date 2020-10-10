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
//        self.contentView.heightAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
        userImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        userImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
