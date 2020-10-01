import UIKit
import FirebaseStorage
import FirebaseFirestore
import GoogleSignIn
import Firebase

class UserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let space:CGFloat = 1
    var userId:String!
    //タブバーから表示されたかsegueから表示されたかを保持
    var fromSegue:Bool = false
    
    var followAry:[Dictionary<String,String>] = []
    var followerAry:[Dictionary<String,String>] = []
    var bestShopNameAry:[String] = []
    var bestShopIdAry:[String] = []
    var userAry:[Dictionary<String,String>] = []
    var postsAry:[Dictionary<String,Any>] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var handle: AuthStateDidChangeListenerHandle!
    var logOutButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var googleSignInButton = GIDSignInButton()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followerListButton: UIButton!
    @IBOutlet weak var followListButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        followListButton.setTitle("フォロー\n0", for: .normal)
        //ボタンのテキストが改行可能に
        followListButton.titleLabel?.numberOfLines = 2
        //ボタンのテキスト中央寄せ
        followListButton.titleLabel!.textAlignment = NSTextAlignment.center
        followerListButton.setTitle("フォロワー\n0", for: .normal)
        followerListButton.titleLabel?.numberOfLines = 2
        followerListButton.titleLabel!.textAlignment = NSTextAlignment.center
        tableView.isScrollEnabled = false
        
        self.followListButton.addTarget(self,action: #selector(self.tapFollowListButton(_ :)),for: .touchUpInside)
        self.followerListButton.addTarget(self,action: #selector(self.tapFollowerListButton(_ :)),for: .touchUpInside)
        logOutButton = UIBarButtonItem(title: "ログアウト", style: .done, target: self, action: #selector(logOutButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = logOutButton
        editButton = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(googleSignInButton)
        googleSignInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.googleSignInButton.isHidden = true
        googleSignInButton.isEnabled = false
        self.logOutButton.isEnabled = false
        self.logOutButton.tintColor = UIColor.clear
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //タブバーから表示されたかsegueから表示されたかで分岐
        if fromSegue{
            //segueから
            //userIdとログインしているユーザー(currentUser)のuidが一致するかで分岐
            if userId == Auth.auth().currentUser?.uid{
                //ログインユーザーのページの場合
                self.verticalStackView.isHidden = false
                self.followButton.isHidden = true
                self.profileLabel.isHidden = false
                self.followListButton.isHidden = false
                self.followerListButton.isHidden = false
                self.userId = "H1xgXJjo1RaIlwRM8Pda"
                self.postsAry = []
                self.followAry = []
                self.followerAry = []
                self.bestShopNameAry = []
                self.bestShopIdAry = []
                let userImgRef = self.storage.child("users").child("\(String(describing: self.userId!)).jpg")
                self.userImageView.sd_setImage(with: userImgRef)
                self.setFollow()
                self.setFollower()
                self.setPosts()
                self.setUser()
                self.logOutButton.isEnabled = true
                self.logOutButton.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                
            }else{
                //その他のユーザーのページの場合
                self.followButton.isHidden = false
                self.postsAry = []
                self.followAry = []
                self.followerAry = []
                self.bestShopNameAry = []
                self.bestShopIdAry = []
                let userImgRef = self.storage.child("users").child("\(String(describing: self.userId!)).jpg")
                self.userImageView.sd_setImage(with: userImgRef)
                self.setFollow()
                self.setFollower()
                self.setPosts()
                self.setUser()
            }
        }else{
            //タブバーから
            //ログイン状態で分岐
                handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                    if user != nil {
                        //ログインの状態
                        self.verticalStackView.isHidden = false
                        self.followButton.isHidden = true
                        self.profileLabel.isHidden = false
                        self.followListButton.isHidden = false
                        self.followerListButton.isHidden = false
                        self.googleSignInButton.isHidden = true
                        self.googleSignInButton.isEnabled = false
                        self.userId = "H1xgXJjo1RaIlwRM8Pda"
                        self.postsAry = []
                        self.followAry = []
                        self.followerAry = []
                        self.bestShopNameAry = []
                        self.bestShopIdAry = []
                        let userImgRef = self.storage.child("users").child("\(String(describing: self.userId!)).jpg")
                        self.userImageView.sd_setImage(with: userImgRef)
                        self.setFollow()
                        self.setFollower()
                        self.setPosts()
                        self.setUser()
                        self.logOutButton.isEnabled = true
                        self.logOutButton.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                    } else {
                        //ログアウトの状態
                        print("nouser")
                        self.verticalStackView.isHidden = true
                        self.followButton.isHidden = true
                        self.profileLabel.isHidden = true
                        self.followListButton.isHidden = true
                        self.followerListButton.isHidden = true
                        self.googleSignInButton.isHidden = false
                        self.googleSignInButton.isEnabled = true
                        self.nameLabel.text = "ログインされていません"
                        self.userImageView.image = nil
                        self.userImageView.backgroundColor = UIColor.gray
                        self.logOutButton.isEnabled = false
                        self.logOutButton.tintColor = UIColor.clear
                    }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //collectionViewの高さを調整
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewConstraintHeight.constant = layout.collectionViewContentSize.height
            view.layoutIfNeeded()
        }
        //tableViewの高さを調整
        tableView.layoutIfNeeded()
        tableViewConstraintHeight.constant = tableView.contentSize.height
    }
    func setFollow(){
        self.db.collection("relationships").whereField("followerId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            if let error = error{
                print(error)
            } else{
                if querySnapshot!.documents.isEmpty{
                    self.followListButton.isEnabled = false
                }else{
                    for document in querySnapshot!.documents{
                        var followDic:Dictionary<String, String> = [:]
                        followDic["userId"] = document["followedId"] as? String
                        followDic["userName"] = document["followedName"] as? String
                        self.followAry.append(followDic)
                        self.followListButton.setTitle("フォロー\n\(String(self.followAry.count))", for: .normal)
                    }
                    
                }
            }
        }
    }
    
    func setFollower(){
        self.db.collection("relationships").whereField("followedId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            if let error = error{
                print(error)
            } else{
                if querySnapshot!.documents.isEmpty{
                    self.followerListButton.isEnabled = false
                }else{
                    for document in querySnapshot!.documents{
                        var followerDic:Dictionary<String, String> = [:]
                        followerDic["userId"] = document["followerId"] as? String
                        followerDic["userName"] = document["followerName"] as? String
                        self.followerAry.append(followerDic)
                        self.followerListButton.setTitle("フォロワー\n\(String(self.followerAry.count))", for: .normal)
                    }
                }
                
            }
        }
    }

    
    func setUser(){
        self.db.collection("users").document(userId).getDocument{(document,error) in
            if let document = document{
                self.profileLabel.text = document.data()?["userProfile"] as? String
                self.bestShopNameAry = (document.data()?["bestShopName"]as? Array) ?? []
                self.bestShopIdAry = (document.data()?["bestShopId"] as? Array) ?? []
                self.tableView.reloadData()
                self.nameLabel.text = document.data()?["userName"] as? String
            }
        }
    }
    
    func setPosts(){
        db.collection("posts").whereField("userId", isEqualTo: userId!).getDocuments(){(querySnapshot, error) in
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
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestShopNameAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        cell.textLabel?.text = "MyBest\(indexPath.row + 1):" + bestShopNameAry[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! CustomCollectionViewCell
        let postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["postId"]!)).jpg")
        let postimageView = UIImageView()
        postimageView.sd_setImage(with: postImgRef)
        let cellSize:CGFloat = (self.view.bounds.width - (space * 2))/3
        cell.imageView.image = postimageView.image?.resized(toWidth: cellSize)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のスペース調整
        let cellSize:CGFloat = (self.view.bounds.width - (space * 2))/3
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    var collectionSelectedNum:Int?
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionSelectedNum = indexPath.row
        performSegue(withIdentifier: "toPostViewController", sender: nil)
    }
    
    
    @objc func tapFollowListButton(_ sender: UIButton){
        userAry = followAry
        print("tap:\(followAry.count)")
        print("tap:\(userAry.count)")
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    @objc func tapFollowerListButton(_ sender: UIButton){
        
        userAry = followerAry
        print("tap:\(followerAry.count)")
        print("tap:\(userAry.count)")
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostViewController" {
            let nextVC = segue.destination as! PostViewController
            nextVC.userName = postsAry[collectionSelectedNum!]["userName"] as? String
            nextVC.userId = userId
            nextVC.shopName = postsAry[collectionSelectedNum!]["shopName"] as? String
            nextVC.shopId = postsAry[collectionSelectedNum!]["shopId"] as? String
            nextVC.postContent = postsAry[collectionSelectedNum!]["postContent"] as? String
            nextVC.postImgRef = self.storage.child("posts").child("\(String(describing: postsAry[collectionSelectedNum!]["postId"]!)).jpg")
            nextVC.userImgRef = self.storage.child("users").child("\(String(describing: postsAry[collectionSelectedNum!]["userId"]!)).jpg")
        }
        else if segue.identifier == "toFollowListViewController"{
            let nextVC = segue.destination as! FollowListViewController
            nextVC.userAry = userAry
            print("prepare:\(userAry.count)")
        }
    }
    @objc func logOutButtonTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
    }
    
}
extension UIImage{
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
