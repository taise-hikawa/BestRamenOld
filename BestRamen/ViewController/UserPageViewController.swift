import UIKit
import FirebaseStorage
import FirebaseFirestore
import GoogleSignIn
import Firebase
import RSKImageCropper

class UserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {
    
    
    let space:CGFloat = 1
    var userId:String!
    //タブバーから表示されたかsegueから表示されたかを保持
    var fromSegue:Bool = false
    var followFlag:Bool = false{
        didSet{
            if followFlag{
                //フォロー中
                followButton.setTitle("フォロー中", for: .normal)
                followButton.backgroundColor = UIColor.white
                followButton.setTitleColor(UIColor.black, for: .normal)
                followButton.layer.borderColor = UIColor.gray.cgColor
                followButton.layer.borderWidth = 1.0
                
            }else{
                //フォローしていない
                followButton.setTitle("フォローする", for: .normal)
                followButton.backgroundColor = UIColor.orange
                followButton.setTitleColor(UIColor.white, for: .normal)
                followButton.layer.borderColor = UIColor.gray.cgColor
                followButton.layer.borderWidth = 0
            }
        }
    }
    
    var followAry:[Dictionary<String,String>] = []
    var followerAry:[Dictionary<String,String>] = []
    var bestShopNameAry:[String] = []
    var bestShopIdAry:[String] = []
    var userAry:[Dictionary<String,String>] = []
    var postsAry:[Dictionary<String,Any>] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    var handle: AuthStateDidChangeListenerHandle?
    var logOutButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var googleSignInButton = GIDSignInButton()
    var currentUser:User!
    var relationId:String!
    var alertController:UIAlertController!
    let postButton = UIButton()
    
//    @IBOutlet weak var postButton: UIButton!
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

    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //投稿ボタンの設定
        
        postButton.setImage(UIImage(named: "camera"), for: .normal)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(postButton)
        postButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        postButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        postButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: (self.view.frame.size.width * 0.08)-(self.tabBarController?.tabBar.frame.size.height)!).isActive = true
        postButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: (self.view.frame.size.width * 0.08)).isActive = true

        self.view.bringSubviewToFront(postButton)
        postButton.backgroundColor = UIColor.orange
        postButton.layer.cornerRadius = self.view.frame.size.width * 0.15
        print(postButton.frame.size.width/2)
        postButton.contentMode = .scaleAspectFit
        postButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        postButton.addTarget(self, action: #selector(self.postButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        postButton.isHidden = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        tableView.delegate = self
        tableView.dataSource = self
        //空の行の線を消す
        tableView.tableFooterView = UIView()
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        followListButton.setTitle("0\nフォロー", for: .normal)
        //ボタンのテキストが改行可能に
        followListButton.titleLabel?.numberOfLines = 2
        //ボタンのテキスト中央寄せ
        followListButton.titleLabel!.textAlignment = NSTextAlignment.center
        followerListButton.setTitle("0\nフォロワー", for: .normal)
        followerListButton.titleLabel?.numberOfLines = 2
        followerListButton.titleLabel!.textAlignment = NSTextAlignment.center
        tableView.isScrollEnabled = false
        
        self.followListButton.addTarget(self,action: #selector(self.tapFollowListButton(_ :)),for: .touchUpInside)
        self.followerListButton.addTarget(self,action: #selector(self.tapFollowerListButton(_ :)),for: .touchUpInside)
        logOutButton = UIBarButtonItem(title: "ログアウト", style: .done, target: self, action: #selector(logOutButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = logOutButton
        editButton = UIBarButtonItem(title: "編集", style: .done, target: self, action: #selector(editButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        logOutButton.isEnabled = false
        logOutButton.tintColor = UIColor.clear
        editButton.isEnabled = false
        editButton.tintColor = UIColor.clear
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(googleSignInButton)
        googleSignInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.googleSignInButton.isHidden = true
        googleSignInButton.isEnabled = false
        
        followButton.addTarget(self, action: #selector(self.followButtonTapped(_:)), for: .touchUpInside)
        followButton.layer.cornerRadius = 8.0
        followButton.layer.masksToBounds = true
        alertController = UIAlertController(title: "ログインが必要です", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        //タブバーから表示されたかsegueから表示されたかで分岐
        if fromSegue{
            //segueから
            self.verticalStackView.isHidden = false
            self.profileLabel.isHidden = false
            self.followListButton.isHidden = false
            self.followerListButton.isHidden = false
            //firestoreの使用量が超えたのでコメントアウト
//            self.storage.child("users").child("\(self.userId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//                if error != nil {
//                    return
//                }
//                if let imageData = data {
//                    let userImg = UIImage(data: imageData)
//                    self.userImageView.image = userImg
//                }
//            }
            self.userImageView.image = UIImage(named: userId)
            self.setFollow()
            self.setFollower()
            self.setPosts()
            self.setUser()
            //userIdとログインしているユーザー(currentUser)のuidが一致するかで分岐
            if userId == currentUser?.uid{
                //ログインユーザーのページの場合
                self.followButton.isHidden = true
                stackViewTopConstraint.priority = UILayoutPriority(rawValue: 1000)
            }else{
                //その他のユーザーのページの場合
                self.followButton.isHidden = false
                stackViewTopConstraint.priority = UILayoutPriority(rawValue: 750)
                if currentUser != nil{
                    self.db.collection("relationships").whereField("followedId", isEqualTo: userId!).whereField("followerId", isEqualTo:currentUser!.uid ).getDocuments{(queryDocumentSnapshot,error) in
                        if let queryDocumentSnapshot = queryDocumentSnapshot,queryDocumentSnapshot.documents.count != 0 {
                            self.followFlag = true
                            for document in queryDocumentSnapshot.documents{
                                self.relationId = document.documentID
                                
                            }
                        }else{
                            self.followFlag = false
                        }
                    }
                    
                }
            }
        }else{
            //タブバーから
            //ログイン状態で分岐
            handle = Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                    if user != nil {
                        //ログインの状態
                        self.verticalStackView.isHidden = false
                        self.followButton.isHidden = true
                        self.stackViewTopConstraint.priority = UILayoutPriority(rawValue: 1000)
                        self.profileLabel.isHidden = false
                        self.followListButton.isHidden = false
                        self.followerListButton.isHidden = false
                        self.googleSignInButton.isHidden = true
                        self.googleSignInButton.isEnabled = false
                        self.userId = auth.currentUser?.uid
                        //firebaseの使用容量を超えたのでコメントアウト
//                        self.storage.child("users").child("\(self.userId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//                            if let error = error {
//                                print(error)
//
//                                return
//                            }
//                            if let imageData = data {
//                                let userImg = UIImage(data: imageData)
//                                self.userImageView.image = userImg
//                            }
//                        }
                        
                        self.userImageView.image = UIImage(named: self.userId)
                        self.setFollow()
                        self.setFollower()
                        self.setPosts()
                        self.setUser()
                        self.logOutButton.isEnabled = true
                        self.logOutButton.tintColor = .white
                        self.editButton.isEnabled = true
                        self.editButton.tintColor = .white
                        self.postButton.isHidden = false
                        self.followButton.isEnabled = false
                        
                    } else {
                        //ログアウトの状態
                        self.verticalStackView.isHidden = true
                        self.followButton.isHidden = true
                        self.profileLabel.isHidden = true
                        self.followListButton.isHidden = true
                        self.followerListButton.isHidden = true
                        self.googleSignInButton.isHidden = false
                        self.googleSignInButton.isEnabled = true
                        self.nameLabel.text = "ログインされていません"
                        self.userImageView.image = nil
                        self.logOutButton.isEnabled = false
                        self.logOutButton.tintColor = UIColor.clear
                        self.editButton.isEnabled = false
                        self.editButton.tintColor = UIColor.clear
                        self.postButton.isHidden = true
                        self.followButton.isEnabled = false
                    }
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let handle = handle{
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    func setFollow(){
        self.db.collection("relationships").whereField("followerId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            self.followAry = []
            if let error = error{
                print(error)
            } else{
                if querySnapshot!.documents.isEmpty{
                    self.followListButton.isEnabled = false
                    self.followListButton.setTitle("0\nフォロー", for: .normal)
                }else{
                    for document in querySnapshot!.documents{
                        var followDic:Dictionary<String, String> = [:]
                        followDic["userId"] = document["followedId"] as? String
                        followDic["userName"] = document["followedName"] as? String
                        self.followAry.append(followDic)
                        self.followListButton.setTitle("\(String(self.followAry.count))\nフォロー", for: .normal)
                        self.followListButton.isEnabled = true
                    }
                    
                }
            }
        }
    }
    
    func setFollower(){
        self.db.collection("relationships").whereField("followedId", isEqualTo: userId!).getDocuments{(querySnapshot, error) in
            self.followerAry = []
            if let error = error{
                print(error)
            } else{
                if querySnapshot!.documents.isEmpty{
                    self.followerListButton.isEnabled = false
                    self.followerListButton.setTitle("0\nフォロワー", for: .normal)
                }else{
                    for document in querySnapshot!.documents{
                        var followerDic:Dictionary<String, String> = [:]
                        followerDic["userId"] = document["followerId"] as? String
                        followerDic["userName"] = document["followerName"] as? String
                        self.followerAry.append(followerDic)
                        self.followerListButton.setTitle("\(String(self.followerAry.count))\nフォロワー", for: .normal)
                        self.followerListButton.isEnabled = true
                    }
                }
                
            }
        }
    }

    
    func setUser(){
        self.db.collection("users").document(userId).getDocument{(document,error) in
            self.bestShopNameAry = []
            self.bestShopIdAry = []
            if let document = document{
                self.profileLabel.text = document.data()?["userProfile"] as? String
                self.bestShopNameAry = (document.data()?["bestShopName"]as? Array) ?? []
                self.bestShopIdAry = (document.data()?["bestShopId"] as? Array) ?? []
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableViewConstraintHeight.constant = self.tableView.contentSize.height
                self.nameLabel.text = document.data()?["userName"] as? String
            }
        }
    }
    
    func setPosts(){
        db.collection("posts").whereField("userId", isEqualTo: userId!).order(by: "createdAt", descending: true).getDocuments(){(querySnapshot, error) in
            self.postsAry = []
            if let querySnapshot = querySnapshot{
                if querySnapshot.documents.count == 0{
                    self.collectionView.reloadData()
                    
                }else{
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
                        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                            self.collectionViewConstraintHeight.constant = layout.collectionViewContentSize.height
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    
    //cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestShopNameAry.count
    }
    //cellの内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        cell.textLabel?.text = "MyBest\(indexPath.row + 1): " + bestShopNameAry[indexPath.row]
        return cell
    }
    //cellが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toShopPageView", sender: nil)
    }
    //cellの数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsAry.count
    }
    //cellの内容を設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! CustomCollectionViewCell
        //firebaseの使用容量を超えたのでコメントアウト
//        storage.child("posts").child("\(String(describing: postsAry[indexPath.row]["postId"]!)).jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
//            if error != nil {
//                return
//            }
//            if let imageData = data {
//                let postImage = UIImage(data: imageData)!
//                let cellSize:CGFloat = (self.view.bounds.width - (self.space * 2))/3
//                cell.imageView.image = postImage.resized(toWidth: cellSize)
//            }
//        }
        let postImage = UIImage(named: postsAry[indexPath.row]["postId"]! as! String) ?? UIImage(named: "a")
        let cellSize:CGFloat = (self.view.bounds.width - (self.space * 2))/3
        cell.imageView.image = postImage!.resized(toWidth: cellSize)
        cell.imageView.contentMode = .scaleAspectFill
        cell.clipsToBounds = true
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    //collectionViewのcellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のスペース調整
        let cellSize:CGFloat = (self.view.bounds.width - (space * 2))/3
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    //cell押下時の処理
    var collectionSelectedNum:Int?
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionSelectedNum = indexPath.row
        performSegue(withIdentifier: "toPostViewController", sender: nil)
    }
    
    //フォローボタン押下時の処理
    @objc func tapFollowListButton(_ sender: UIButton){
        userAry = followAry
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    //フォロワーボタン押下時の処理
    @objc func tapFollowerListButton(_ sender: UIButton){
        userAry = followerAry
        self.performSegue(withIdentifier: "toFollowListViewController", sender: nil)
    }
    //segueによる画面遷移時の値受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostViewController" {
            let nextVC = segue.destination as! PostViewController
            nextVC.userName = postsAry[collectionSelectedNum!]["userName"] as? String
            nextVC.userId = userId
            nextVC.shopName = postsAry[collectionSelectedNum!]["shopName"] as? String
            nextVC.shopId = postsAry[collectionSelectedNum!]["shopId"] as? String
            nextVC.postContent = postsAry[collectionSelectedNum!]["postContent"] as? String
            nextVC.postId = postsAry[collectionSelectedNum!]["postId"] as? String
        }
        else if segue.identifier == "toFollowListViewController"{
            let nextVC = segue.destination as! FollowListViewController
            nextVC.userAry = userAry
        }else if segue.identifier == "toEditView"{
            let nextVC = segue.destination as! EditViewController
            nextVC.userId = userId
            nextVC.userName = nameLabel.text
            nextVC.userProfile = profileLabel.text
            nextVC.bestShopNameAry = bestShopNameAry
            nextVC.bestShopIdAry = bestShopIdAry
        }else if segue.identifier == "toShopPageView"  {
            let nextVC = segue.destination as! ShopPageViewController
            let row = self.tableView.indexPathForSelectedRow?.row
            nextVC.shopId = bestShopIdAry[row!]
        }else if segue.identifier == "toMakePostView"{
            let nextVC = segue.destination as! MakePostViewController
            //次の画面のインスタンスに取得した画像を渡す
            nextVC.captureImage = captureImage
        }
    }
    //ログアウトボタン押下時の処理
    @objc func logOutButtonTapped(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //編集ボタン押下時の処理
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toEditView", sender: nil)
    }
    //フォローボタン押下時の処理
    @objc func followButtonTapped(_ sender: UIBarButtonItem) {
        if followFlag{
            db.collection("relationships").document(relationId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.followFlag = false
                    self.setFollower()
                }
            }
        }else{
            if currentUser != nil{
                //ログイン中
                var ref: DocumentReference?
                ref = db.collection("relationships").addDocument(data: [
                    "followedId": userId!,
                    "followedName": self.nameLabel.text!,
                    "followerId": currentUser.uid,
                    "followerName":currentUser.displayName!
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully added!")
                        self.followFlag = true
                        self.relationId = ref?.documentID
                        self.setFollower()
                    }
                }
            }else{
                //ログアウト中はポップアップを表示
                //アラートコントローラーを作成する。
                
                self.present(alertController, animated: true, completion:nil)
                
            }
        }
    }
    //投稿ボタン押下時の処理
    @objc func postButtonTapped(_ sender: UIBarButtonItem) {
        //カメラがフォトライブラリーどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        //バグ"width == - 16 の Auto Layout 警告"が出るのを回避
        alertController.pruneNegativeWidthConstraints()
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラを起動するための選択肢を定義
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action) in
                //カメラを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
                
            })
            alertController.addAction(cameraAction)
        }
        //フォトライブラリーが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //フォトライブラリーを起動するための選択肢を定義
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action) in
                //カメラを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
                
            })
            alertController.addAction(photoLibraryAction)
        }
        //キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        //iPadで落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        //選択肢を画面に表示
        present(alertController, animated: true, completion: nil)
    }
    //次の画面遷移する時に渡す画像を格納する場所
    var captureImage : UIImage?
    var imageCropVC:RSKImageCropViewController!
    //撮影が終わった時に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            //(2)撮影した画像を配置したpictureImageに渡す
            self.captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.imageCropVC = RSKImageCropViewController(image: self.captureImage!, cropMode: .square)
            self.imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
            self.imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
            self.imageCropVC.chooseButton.setTitle("完了", for: .normal)
            self.imageCropVC.delegate = self
            self.present(self.imageCropVC, animated: true)
        })
        
    }
    
    
    //キャンセルを押した時の処理
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //モーダルビューを閉じる
        dismiss(animated: true, completion: {
            self.captureImage = croppedImage
            //エフェクト画面に遷移
            self.performSegue(withIdentifier: "toMakePostView", sender: nil)
            
        })
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
//バグ"width == - 16 の Auto Layout 警告"が出るのを回避
extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
