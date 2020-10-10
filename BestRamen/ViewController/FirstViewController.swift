import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var postDic:Dictionary<String, Any> = [:]
    var postsAry:[Dictionary<String,Any>] = []
    //    var postImg = UIImage()
    //    var userImg = UIImage()
    var postImgAry:[UIImage] = []
    var userImgAry:[UIImage] = []
    var imageSetFlag:Dictionary<String,Bool> = ["post": false,"user": false]{
        didSet{
            if imageSetFlag.values.contains(false){
            }else{
                homeTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.estimatedRowHeight = 290
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        //空の行の線を消す
        homeTableView.tableFooterView = UIView()
        
        
        
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
                }
                self.imageSet()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsAry.count
    }
    func imageSet(){
        userImgAry = []
        postImgAry = []
        for post in self.postsAry.enumerated(){
            self.storage.child("posts").child("\(String(describing: post.element["postId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
                if error != nil {
                    return
                }
                if let imageData = data {
                    self.postImgAry.append(UIImage(data: imageData)!)
                    if self.postImgAry.count == self.postsAry.count{
                        self.imageSetFlag["post"] = true
                    }
                }
            }
            self.storage.child("users").child("\(String(describing:post.element["userId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
                if error != nil {
                    return
                }
                if let imageData = data {
                    self.userImgAry.append(UIImage(data: imageData)!)
                    if self.userImgAry.count == self.postsAry.count{
                        self.imageSetFlag["user"] = true
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        
        cell.userName.text = postsAry[indexPath.row]["userName"] as? String
        cell.shopName.text = postsAry[indexPath.row]["shopName"] as? String
        if userImgAry.count != 0{
            cell.userImageView.image = userImgAry[indexPath.row]
            cell.setPostedImage(image: postImgAry[indexPath.row])
        }
        return cell
    }
    
    //セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // 別の画面に遷移
        performSegue(withIdentifier: "toNextViewController", sender: nil)
        
    }
    //画面遷移時の値の引き渡し
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
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
}

