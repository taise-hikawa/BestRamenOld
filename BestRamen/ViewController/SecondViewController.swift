import UIKit
import MapKit
import Firebase

class SecondViewController: UIViewController ,MKMapViewDelegate{
    
    let db = Firestore.firestore()
    var shopsAry:[Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShops()
        mapView.delegate = self
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
                    for document in querySnapshot.documents{
                        self.shopsAry.append(document.data())
                        print(self.shopsAry)
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
            print(type(of: latitude))
            let place = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
            let pin: MKPointAnnotation = MKPointAnnotation()
            pin.coordinate = place
            //            pin.
            mapView.addAnnotation(pin)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //        if (annotation is MKUserLocation) {
        //            // ユーザの現在地の青丸マークは置き換えない
        //            return nil
        //        } else {}
        // CustomAnnotationの場合に画像を配置
        // MKPinAnnotationViewを宣言
        let annoView = MKPinAnnotationView()
        // MKPinAnnotationViewのannotationにMKAnnotationのAnnotationを追加
        annoView.annotation = annotation
        // ピンの画像を変更
        annoView.image = UIImage(named: "ramenIcon")?.resized(toWidth: self.view.bounds.width/15)
//        // 吹き出しを使用
//        annoView.canShowCallout = true
//        // 吹き出しにinfoボタンを表示
//        annoView.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        
        return annoView
        //        if annotationView == nil {
//            annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
//        }
//        annotationView?.image = UIImage.init(named: "a") // 任意の画像名
//        annotationView?.annotation = annotation
//        annotationView!.canShowCallout = true  // タップで吹き出しを表示
//        return annotationView
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    

}

