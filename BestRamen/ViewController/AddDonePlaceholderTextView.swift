import Foundation
import UIKit

@IBDesignable class AddDonePlaceholderTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addDelete()
        addObserver()
        // 枠のカラー
        self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        // 枠の幅
        self.layer.borderWidth = 1.0
        
        // 枠を角丸にする
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addDelete()
        addObserver()
        // 枠のカラー
        self.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        
        // 枠の幅
        self.layer.borderWidth = 1.0
        
        // 枠を角丸にする
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

    private func addDelete(){
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
        //閉じるボタンを配置するためのスペース
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeButtonTapped))
        // スペース、閉じるボタンを右側に配置
        tools.items = [spacer, closeButton]
        // textViewのキーボードにツールバーを設定
        self.inputAccessoryView = tools
    }
    
    @objc func closeButtonTapped(){
        self.endEditing(true)
        self.resignFirstResponder()
    }
    
    @IBInspectable var placeHolder: String = ""
    @IBInspectable var placeHolderColor: UIColor = .lightGray

    private var placeHolderLayer: CATextLayer?

    private func createPlaceHolderLayerIfNeed() {
        if placeHolderLayer == nil {
            let layer = CATextLayer()
            layer.fontSize = self.font?.pointSize ?? UIFont.systemFontSize
            layer.frame = CGRect(x: self.textContainerInset.left + self.textContainer.lineFragmentPadding, y: self.textContainerInset.top, width: self.frame.width, height: layer.fontSize+10)
            layer.string = self.placeHolder
            layer.foregroundColor = placeHolderColor.cgColor
            layer.contentsScale = UIScreen.main.scale
            layer.alignmentMode = CATextLayerAlignmentMode.left
            self.layer.addSublayer(layer)
            placeHolderLayer = layer
        }
    }

    private func removePlaceHolderLayerIfNeed() {
        placeHolderLayer?.removeFromSuperlayer()
        placeHolderLayer = nil
    }

    private func updateLayer() {
        // Observerから呼ばれるとmainじゃないかも？
        DispatchQueue.main.async {
            if self.text == nil || self.text.isEmpty {
                self.createPlaceHolderLayerIfNeed()
            } else {
                self.removePlaceHolderLayerIfNeed()
            }
        }
    }

    @objc func onChangedText(_ notification: NSNotification?) {
        updateLayer()
    }

    // MARK: Observer関連
    private func addObserver() {
        updateLayer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onChangedText(_:)), name: UITextView.textDidChangeNotification, object: self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
