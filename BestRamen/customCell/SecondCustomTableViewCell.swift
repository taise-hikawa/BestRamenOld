//
//  SecondCustomTableViewCell.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/10/02.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class SecondCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAdressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
