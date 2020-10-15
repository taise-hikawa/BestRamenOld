import UIKit
import FirebaseStorage
import FirebaseFirestore
import FloatingPanel
import Firebase
protocol RamenChooseViewControllerDelegate{
    func ramenChooseDidFinished(shopName: String,shopId: String,rank: Int)
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,FloatingPanelControllerDelegate ,RamenChooseViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate{
    
    var userName:String!
    var userProfile:String!
    var userId:String!
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    
    var bestShopNameAry:Array<String>!{
        didSet{
            bestShopCount = bestShopNameAry.count
        }
    }
    var bestShopCount:Int!{
        didSet{
            if editOneButton == nil{return}
            switch bestShopCount{
            case 0:
                bestOneLabel.text = "best1: 未設定"
                bestTwoLabel.text = "best2: 未設定"
                bestThreeLabel.text = "best3: 未設定"
                editOneButton.setTitle("追加", for: .normal)
                editTwoButton.isHidden = true
                editThreeButton.isHidden = true
                oneDeleteButton.isHidden = true
                twoDeleteButton.isHidden = true
                threeDeleteButton.isHidden = true
            case 1:
                bestOneLabel.text = "best1: \(bestShopNameAry[0])"
                bestTwoLabel.text = "best2: 未設定"
                bestThreeLabel.text = "best3: 未設定"
                editOneButton.setTitle("編集", for: .normal)
                editTwoButton.setTitle("追加", for: .normal)
                editTwoButton.isHidden = false
                editThreeButton.isHidden = true
                oneDeleteButton.isHidden = false
                twoDeleteButton.isHidden = true
                threeDeleteButton.isHidden = true
            case 2:
                bestOneLabel.text = "best1: \(bestShopNameAry[0])"
                bestTwoLabel.text = "best2: \(bestShopNameAry[1])"
                bestThreeLabel.text = "best3: 未設定"
                editOneButton.setTitle("編集", for: .normal)
                editTwoButton.setTitle("編集", for: .normal)
                editThreeButton.setTitle("追加", for: .normal)
                editTwoButton.isHidden = false
                editThreeButton.isHidden = false
                oneDeleteButton.isHidden = true
                twoDeleteButton.isHidden = false
                threeDeleteButton.isHidden = true
            case 3:
                bestOneLabel.text = "best1: \(bestShopNameAry[0])"
                bestTwoLabel.text = "best2: \(bestShopNameAry[1])"
                bestThreeLabel.text = "best3: \(bestShopNameAry[2])"
                editOneButton.setTitle("編集", for: .normal)
                editTwoButton.setTitle("編集", for: .normal)
                editThreeButton.setTitle("編集", for: .normal)
                editTwoButton.isHidden = false
                editThreeButton.isHidden = false
                oneDeleteButton.isHidden = true
                twoDeleteButton.isHidden = true
                threeDeleteButton.isHidden = false
            default:
                print("error")
            }
        }
    }
    
    
    var bestShopIdAry:Array<String>!
    
    var floatingPanelController: FloatingPanelController!
    var saveButton: UIBarButtonItem!
    var changeFlag:Dictionary<String,Bool> = ["userImage":false,"userName":false,"userProfile":false,"bestRamen":false]{
        didSet{
            if saveButton == nil{return}
            if changeFlag.values.contains(true){
                saveButton.isEnabled = true
            }else{
                saveButton.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var oneDeleteButton: UIButton!
    @IBOutlet weak var twoDeleteButton: UIButton!
    @IBOutlet weak var threeDeleteButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var bestOneLabel: UILabel!
    @IBOutlet weak var bestTwoLabel: UILabel!
    @IBOutlet weak var bestThreeLabel: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var textView: AddDonePlaceholderTextView!
    @IBOutlet weak var editOneButton: UIButton!
    @IBOutlet weak var editTwoButton: UIButton!
    @IBOutlet weak var editThreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.text = userName
        textView.text = userProfile
        userNameField.delegate = self
        textView.delegate = self
        storage.child("users").child("\(userId ?? "").jpg").getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let userImg = UIImage(data: imageData)
                self.userImageView.image = userImg
            }
        }
        changeImageButton.addTarget(self, action: #selector(self.tapChangeImageButton(_:)), for: .touchUpInside)
        editOneButton.addTarget(self, action: #selector(self.tapEditOneButton(_:)), for: .touchUpInside)
        editTwoButton.addTarget(self, action: #selector(self.tapEditTwoButton(_:)), for: .touchUpInside)
        editThreeButton.addTarget(self, action: #selector(self.tapEditThreeButton(_:)), for: .touchUpInside)
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(self.tapSaveButton(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = false
        oneDeleteButton.addTarget(self, action: #selector(self.tapDeleteButton(_:)), for: .touchUpInside)
        twoDeleteButton.addTarget(self, action: #selector(self.tapDeleteButton(_:)), for: .touchUpInside)
        threeDeleteButton.addTarget(self, action: #selector(self.tapDeleteButton(_:)), for: .touchUpInside)
        switch bestShopCount{
        case 0:
            bestOneLabel.text = "best1: 未設定"
            bestTwoLabel.text = "best2: 未設定"
            bestThreeLabel.text = "best3: 未設定"
            editOneButton.setTitle("追加", for: .normal)
            editTwoButton.isHidden = true
            editThreeButton.isHidden = true
            oneDeleteButton.isHidden = true
            twoDeleteButton.isHidden = true
            threeDeleteButton.isHidden = true
        case 1:
            bestOneLabel.text = "best1: \(bestShopNameAry[0])"
            bestTwoLabel.text = "best2: 未設定"
            bestThreeLabel.text = "best3: 未設定"
            editOneButton.setTitle("編集", for: .normal)
            editTwoButton.setTitle("追加", for: .normal)
            editTwoButton.isHidden = false
            editThreeButton.isHidden = true
            oneDeleteButton.isHidden = false
            twoDeleteButton.isHidden = true
            threeDeleteButton.isHidden = true
        case 2:
            bestOneLabel.text = "best1: \(bestShopNameAry[0])"
            bestTwoLabel.text = "best2: \(bestShopNameAry[1])"
            bestThreeLabel.text = "best3: 未設定"
            editOneButton.setTitle("編集", for: .normal)
            editTwoButton.setTitle("編集", for: .normal)
            editThreeButton.setTitle("追加", for: .normal)
            editTwoButton.isHidden = false
            editThreeButton.isHidden = false
            oneDeleteButton.isHidden = true
            twoDeleteButton.isHidden = false
            threeDeleteButton.isHidden = true
        case 3:
            bestOneLabel.text = "best1: \(bestShopNameAry[0])"
            bestTwoLabel.text = "best2: \(bestShopNameAry[1])"
            bestThreeLabel.text = "best3: \(bestShopNameAry[2])"
            editOneButton.setTitle("編集", for: .normal)
            editTwoButton.setTitle("編集", for: .normal)
            editThreeButton.setTitle("編集", for: .normal)
            editTwoButton.isHidden = false
            editThreeButton.isHidden = false
            oneDeleteButton.isHidden = true
            twoDeleteButton.isHidden = true
            threeDeleteButton.isHidden = false
        default:
            print("error")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureObserver()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Notificationを画面が消えるときに削除
        self.removeObserver()
        // セミモーダルビューを非表示にする
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //textFieldに入力が行われる直前に呼ばれる。
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //スペースの入力を無効
        if string.contains(" ")||string.contains("　"){
            return false
        }
        // textField内の文字数
        let textFieldNumber = textField.text?.count ?? 0
        // 入力された文字数
        let stringNumber = string.count
        // 文字数最大値を定義
        let maxLength = 10
        return textFieldNumber + stringNumber <= maxLength
    }
    //textViewに入力が行われる直前に呼ばれる。
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // textField内の文字数
        let textViewNumber = textView.text?.count ?? 0
        // 入力された文字数
        let textNumber = text.count
        // 文字数最大値を定義
        let maxLength = 100
        return textViewNumber + textNumber <= maxLength
    }
    //textFieldの変化ごとに呼ばれる。空か判定しchangeFlagを変化
    @IBAction func usrNameFieldEditingChanged(_ sender: Any) {
        
        if userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            changeFlag["userName"] = false
        }else{
            changeFlag["userName"] = true
        }
        
    }
    //textViewの変化ごとに呼ばれる。
    func textViewDidChange(_ textView: UITextView) {
        changeFlag["userProfile"] = true
        
    }
    // キーボードを閉じる（returnキーを押下時）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    // キーボードを閉じる（UITextField以外の部分を押下時）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (textView.isFirstResponder) {
            textView.resignFirstResponder()
        }
        if(userNameField.isFirstResponder){
            userNameField.resignFirstResponder()
        }
    }
    @objc func tapEditOneButton(_ sender: Any){
        toBestChoose(rank: 1)
    }
    @objc func tapEditTwoButton(_ sender: Any){
        toBestChoose(rank: 2)
    }
    @objc func tapEditThreeButton(_ sender: Any){
        toBestChoose(rank: 3)
    }
    func toBestChoose(rank: Int){
        let ramenChooseViewController = self.storyboard?.instantiateViewController(withIdentifier: "fpc2") as? RamenChooseViewController
        if floatingPanelController != nil{
            floatingPanelController.removePanelFromParent(animated: true)
        }
        floatingPanelController = FloatingPanelController()
        ramenChooseViewController?.delegate = self
        ramenChooseViewController?.rank = rank
        floatingPanelController.set(contentViewController: ramenChooseViewController)
        floatingPanelController.delegate = self
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self)
    }
    @objc func tapSaveButton(_ sender: Any){
        let mydb = Firestore.firestore().collection("users").document(userId)
        if changeFlag["userImage"] == true{
            let storageref = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com").child("users").child("\(userId ?? "").jpg")
            //画像
            let image = userImageView.image
            //imageをNSDataに変換
            let data = image!.jpegData(compressionQuality: 0.005)
            //メタデータを設定
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            //Storageに保存
            storageref.putData(data!, metadata: metaData) { (data, error) in
                if error != nil {
                    return
                }
            }
        }
        if changeFlag["userName"] == true{
            mydb.setData(["userName":userNameField.text ?? "no name"],merge: true){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userNameField.text
                    changeRequest?.commitChanges { (error) in
                      // ...
                    }
                }
            }
        }
        if changeFlag["userProfile"] == true{
            mydb.setData(["userProfile":textView.text ?? ""],merge: true){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        if changeFlag["bestRamen"] == true{
            mydb.setData([
                "bestShopName":bestShopNameAry ?? [],
                "bestShopId":bestShopIdAry ?? []
            ],merge: true){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        changeFlag = ["userImage":false,"userName":false,"userProfile":false,"bestRamen":false]
    }
    
    @objc func tapDeleteButton(_ sender: Any){
        bestShopNameAry.removeLast()
        bestShopIdAry.removeLast()
        changeFlag["bestRamen"] = true
        
    }
    @objc func tapChangeImageButton(_ sender: Any){
        //カメラがフォトライブラリーどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
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
    
    //撮影が終わった後呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //撮影した画像をuserImageViewに設定
        userImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //saveButtonを使用可能にする
        changeFlag["userImage"] = true
        //モーダルビューを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    func ramenChooseDidFinished(shopName: String, shopId: String, rank: Int) {
        if bestShopNameAry.count == rank-1{
            bestShopNameAry.append(shopName)
            bestShopIdAry.append(shopId)
        }else{
            bestShopNameAry[rank-1] = shopName
            bestShopIdAry[rank-1] = shopId
        }
        changeFlag["bestRamen"] = true
        floatingPanelController.removePanelFromParent(animated: true)
        
    }
    // カスタマイズしたレイアウトに変更
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
    //tipの位置になったらモーダルを終了
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state == FloatingPanelState.tip{
            fpc.removePanelFromParent(animated: true, completion: nil)
        }
    }
    
    private var activeTextField: UITextField? = nil
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        activeTextField = textField
        return true
    }
    private var activeTextView: UITextView? = nil
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        activeTextView = textView
        return true
    }
    
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        print("show")
        guard let userInfo = notification?.userInfo,
              let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboard.cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        //FirstResponderによって分岐
        var textframeParent:CGRect!
        if (textView.isFirstResponder) {
            // textViewの座標を全体座標に変換
            textframeParent = activeTextView?.frame
        }
        if(userNameField.isFirstResponder){
            // textFieldの座標を全体座標に変換
            textframeParent = activeTextField?.frame
        }
        
        let txtLimit = textframeParent.origin.y + textframeParent.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        let moveY = txtLimit - kbdLimit
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if moveY >= 0{
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(moveY))
                self.view.transform = transform
                
            })
        }
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        print("hide")
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}


