import UIKit
import MapKit
import Firebase
import FloatingPanel

class SecondViewController: UIViewController ,MKMapViewDelegate,FloatingPanelControllerDelegate{

    
    var floatingPanelController: FloatingPanelController!
    let db = Firestore.firestore()
    var shopsAry:[Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShops()
        mapView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // セミモーダルビューを非表示にする
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setShops(){
        // 非同期のグループ作成
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")
        dispatchGroup.enter()
        dispatchQueue.async {
            self.db.collection("shops").getDocuments{(querySnapshot,error) in
                if let querySnapshot =  querySnapshot {
                    for (num,document) in querySnapshot.documents.enumerated(){
                        self.shopsAry.append(document.data())
                        self.shopsAry[num]["shopId"] = document.documentID
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            self.shopMapping()
        }
        
    }
    func shopMapping(){
        for shop in shopsAry{
            let latitude = (shop["shopGeocode"] as? GeoPoint)?.latitude
            let longitude = (shop["shopGeocode"] as? GeoPoint)?.longitude
            let place = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
            let pin: MyPointAnnotation = MyPointAnnotation()
            pin.coordinate = place
            pin.shopName = shop["shopName"] as? String
            pin.shopId = shop["shopId"] as? String
            pin.shopAdress = shop["shopAdress"] as? String
            mapView.addAnnotation(pin)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // MKPinAnnotationViewを宣言
        let annoView = MKPinAnnotationView()
        // MKPinAnnotationViewのannotationにMKAnnotationのAnnotationを追加
        annoView.annotation = annotation
        // ピンの画像を変更
        annoView.image = UIImage(named: "ramenIcon")?.resized(toWidth: self.view.bounds.width/15)
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
        let annotation = view.annotation as? MyPointAnnotation
        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
        let semiModalViewController = self.storyboard?.instantiateViewController(withIdentifier: "fpc") as? SemiModalViewController
        semiModalViewController?.shopName = annotation?.shopName
        semiModalViewController?.shopAdress = annotation?.shopAdress
        semiModalViewController?.shopId = annotation?.shopId
        floatingPanelController = FloatingPanelController()
        semiModalViewController?.floatingPanelController = floatingPanelController
        floatingPanelController.set(contentViewController: semiModalViewController)
        floatingPanelController.delegate = self
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
        //選択を解除する
        for annotaion in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotaion, animated: false)
        }
    }
    // カスタマイズしたレイアウトに変更
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
    //tipの位置になったらモーダルを終了
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition == .tip{
            vc.removePanelFromParent(animated: true)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    

}

class MyPointAnnotation : MKPointAnnotation {
    var shopName: String?
    var shopId:String?
    var shopAdress:String?
}
