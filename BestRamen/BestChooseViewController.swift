import UIKit
import FirebaseFirestore
import FloatingPanel
class BestChooseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let db = Firestore.firestore()
    var shopsAry:Array<Dictionary<String, String>> = []
    var delegate: BestChooseViewControllerDelegate!
    var rank:Int!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SecondCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondCustomCell")
        setShops()
    }
    //セルの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsAry.count
    }
    //セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCustomCell") as! SecondCustomTableViewCell
        cell.shopNameLabel.text = shopsAry[indexPath.row]["shopName"]
        cell.shopAdressLabel.text = shopsAry[indexPath.row]["shopAdress"]
        return cell
    }
    //セルの選択時に呼び出し
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate.bestChooseDidFinished(shopName: shopsAry[indexPath.row]["shopName"]!, shopId: shopsAry[indexPath.row]["shopId"]!, rank: rank)
        
    }
    func setShops(){
        db.collection("shops").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    var shopDic:Dictionary<String, String> = [:]
                    shopDic["shopName"] = document.data()["shopName"] as? String
                    shopDic["shopAdress"] = document.data()["shopAdress"] as? String
                    shopDic["shopId"] = document.documentID
                    self.shopsAry.append(shopDic)
                    self.tableView.reloadData()
                }
            }
        }
    }
}



