import UIKit
import MapKit
import Firebase

class SecondViewController: UIViewController {
    
    let db = Firestore.firestore()
    var shopsAry:[Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShops()
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
            pin.title = "タイトル"
            mapView.addAnnotation(pin)
        }
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    

}

