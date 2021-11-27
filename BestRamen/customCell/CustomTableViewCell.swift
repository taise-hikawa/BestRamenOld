//
//  CustomCellTableViewCell.swift
//  BestRamen
//
//  Created by Taisei Hikawa on 2020/09/05.
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
        }
        return size
        
    }
    
    
    func setPostedImage(image : UIImage) {
        aspect = image.size.width / image.size.height
        postImageView.image = image
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/aspect).isActive = true
        postImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        postImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var shopName: UILabel!
    
    func initSelf(item: Post) {
        postImageView.contentMode = .scaleAspectFill
        userName.text = item.userName
        shopName.text = item.shopName
        userImageView.image = UIImage(named: item.userId.description)
        if let postImage = UIImage(named: item.postId.description) {
            setPostedImage(image: postImage)
        }
    }
    
    //セルの再表示処理
    override func prepareForReuse() {
        super.prepareForReuse()
        //再表示の際にconstraintが残っているため初期化する
        self.removeConstraints(self.constraints)
        postImageView.removeConstraints(postImageView.constraints)
  
    }
    //Storyboardまたはnibファイルからロードされた直後に呼ばれる
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //選択状態と通常状態の状態アニメーション処理
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
