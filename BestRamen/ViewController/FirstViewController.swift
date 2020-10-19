import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var postsAry:[Dictionary<String,Any>] = []
    var postImgDic:Dictionary<String,UIImage> = [:]
    var userImgDic:Dictionary<String,UIImage> = [:]
    var userCount:Int = 0
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        imageSetFlag = ["post": false,"user": false]
        postsAry = []
        userImgDic = [:]
        postImgDic = [:]
        userCount = 0
        setPosts()
    }
    func setPosts(){
        db.collection("posts").order(by: "createdAt", descending: true).getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                for document in querySnapshot.documents{
                    var postDic:Dictionary<String, Any> = [:]
                    postDic["userName"] = document.data()["userName"] as? String
                    postDic["userId"] = document.data()["userId"] as? String
                    postDic["shopName"] = document.data()["shopName"] as? String
                    postDic["shopId"] = document.data()["shopId"] as? String
                    postDic["postContent"] = document.data()["postContent"] as? String
                    postDic["postId"] = document.documentID
                    self.postsAry.append(postDic)
                }
                self.imageSet()
            }
        }
    }
    func imageSet(){
        for post in self.postsAry.enumerated(){
            //firestoreの使用量が超えたのでコメントアウト
//            self.storage.child("posts").child("\(String(describing: post.element["postId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                if let imageData = data {
//                    print("succeed",imageData)
//                    self.postImgDic.updateValue(UIImage(data: imageData)!, forKey: post.element["postId"] as! String)
//                    if self.postImgDic.count == self.postsAry.count{
//                        self.imageSetFlag["post"] = true
//                    }
//                }
//            }
//            self.storage.child("users").child("\(String(describing:post.element["userId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                if let imageData = data {
//                    print("succeed",imageData)
//                    self.userImgDic.updateValue(UIImage(data: imageData)!, forKey: post.element["userId"] as! String)
//                    self.userCount += 1
//                    if self.userCount == self.postsAry.count{
//                        self.imageSetFlag["user"] = true
//                    }
//                }
//            }
            //firestoreの使用量が超えた時用にデフォルトの画像を表示
            self.postImgDic.updateValue((UIImage(named: post.element["postId"] as! String) ?? UIImage(named: "a"))!, forKey: post.element["postId"] as! String)
            if self.postImgDic.count == self.postsAry.count{
                self.imageSetFlag["post"] = true
            }
            self.userImgDic.updateValue(UIImage(named: post.element["userId"] as! String)!, forKey: post.element["userId"] as! String)
            self.userCount += 1
            if self.userCount == self.postsAry.count{
                self.imageSetFlag["user"] = true
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルをカスタムセルに
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        if postsAry.count > 0{
            cell.userName.text = postsAry[indexPath.row]["userName"] as? String
            cell.shopName.text = postsAry[indexPath.row]["shopName"] as? String
            if (userCount == postsAry.count)&&(postImgDic.count == postsAry.count){
                cell.userImageView.image = userImgDic[postsAry[indexPath.row]["userId"] as! String]
                cell.setPostedImage(image: postImgDic[postsAry[indexPath.row]["postId"] as! String]!)
            }
        }
        return cell
    }
    
    //セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // 別の画面に遷移
        if postsAry.count-1 >= indexPath.row{
            performSegue(withIdentifier: "toNextViewController", sender: nil)
        }
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

