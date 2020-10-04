import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var postDic:Dictionary<String, Any> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        setPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    func setPosts(){
        db.collection("posts").getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    self.postDic["userName"] = document.data()["userName"] as? String
                    self.postDic["userId"] = document.data()["userId"] as? String
                    self.postDic["shopName"] = document.data()["shopName"] as? String
                    self.postDic["shopId"] = document.data()["shopId"] as? String
                    self.postDic["postContent"] = document.data()["postContent"] as? String
                    self.postDic["postId"] = document.documentID
                    self.postsAry.append(self.postDic)
                    self.homeTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["postId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let postImg = UIImage(data: imageData)
                cell.postImageView.image = postImg
            }
        }
        storage.child("users").child("\(String(describing: postsAry[indexPath.row]["userId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let userImg = UIImage(data: imageData)
                cell.userImageView.image = userImg
            }
        }
        cell.userName.text = postsAry[indexPath.row]["userName"] as? String
        cell.shopName.text = postsAry[indexPath.row]["shopName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // 別の画面に遷移
        performSegue(withIdentifier: "toNextViewController", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController" {
            let nextVC = segue.destination as! PostViewController
            let row = self.homeTableView.indexPathForSelectedRow?.row
            nextVC.userName = postsAry[row!]["userName"] as? String
            nextVC.userId = postsAry[row!]["userId"] as? String
            nextVC.shopName = postsAry[row!]["shopName"] as? String
            nextVC.shopId = postsAry[row!]["shopId"] as? String
            nextVC.postContent = postsAry[row!]["postContent"] as? String
            nextVC.postId = postsAry[row!]["postId"] as? String
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width
    }
    

    @IBOutlet weak var homeTableView: UITableView!
    


}

