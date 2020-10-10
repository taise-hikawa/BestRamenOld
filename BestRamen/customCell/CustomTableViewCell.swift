//
//  CustomCellTableViewCell.swift
//  BestRamen
//
//  Created by Sakurako Shimbori on 2020/09/05.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var aspect:CGFloat!
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        var size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
        if aspect != nil{
            size.height = size.width/aspect
            print("systemLayoutSizeFitting")
        }
        return size
        
    }
    
    
    func setPostedImage(image : UIImage) {
        print("setPostedImage")
        aspect = image.size.width / image.size.height
        print(image.size.width)
        print(image.size.height)
        postImageView.image = image
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/aspect).isActive = true
        postImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        postImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        // 枠線の色
        self.layer.borderColor = UIColor.red.cgColor
        // 枠線の太さ
        self.layer.borderWidth = 10
        
        // 枠線の色
        self.contentView.layer.borderColor = UIColor.blue.cgColor
        // 枠線の太さ
        self.contentView.layer.borderWidth = 6
        
        // 枠線の色
        self.postImageView.layer.borderColor = UIColor.green.cgColor
        // 枠線の太さ
        self.postImageView.layer.borderWidth = 3
        
    }

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
  
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
