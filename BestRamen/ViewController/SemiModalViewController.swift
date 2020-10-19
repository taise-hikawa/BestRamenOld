import UIKit
import FloatingPanel

class SemiModalViewController: UIViewController {

    var shopName:String!
    var shopAdress:String!
    var shopId:String!
    var floatingPanelController: FloatingPanelController!

    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAdressLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailButton.addTarget(self, action: #selector(self.tapDetailButton(_:)), for: .touchUpInside)
        detailButton.layer.cornerRadius = 8.0
        detailButton.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(self.tapCloseButton(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        shopNameLabel.text = shopName
        shopAdressLabel.text = shopAdress
    }
    @objc func tapCloseButton(_ sender: UIButton){
        floatingPanelController.removePanelFromParent(animated: true)
        
        
    }
    @objc func tapDetailButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "toShopPageViewController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toShopPageViewController"{
            let nextVC = segue.destination as! ShopPageViewController
            nextVC.shopId = shopId
            
        }
    }
}
