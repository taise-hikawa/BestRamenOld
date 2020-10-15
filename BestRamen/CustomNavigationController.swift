import Foundation
import UIKit
class CustomNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setDesign()
        let image = UIImage(named: "BestRamen")!
        setImage(image: image)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDesign()
        let image = UIImage(named: "BestRamen")!
        setImage(image: image)
    }
    
    func setDesign(){
        //　ナビゲーションバーの背景色
        self.navigationBar.barTintColor = .orange
        // ナビゲーションバーのアイテムの色
        self.navigationBar.tintColor = .white

    }
    func setImage(image : UIImage){
        //ナビゲーションバーに画像を設定
        let imageView = UIImageView(image: image)
        self.navigationBar.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.navigationBar.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.35).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.navigationBar.heightAnchor, multiplier: 0.8).isActive = true
    }
}

