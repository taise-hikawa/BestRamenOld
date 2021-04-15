//
//  EditProfileView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @State private var showActionSheet = false
    @State private var name = ""
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            HStack {
                Image("default")
                Button(action: {showActionSheet.toggle()}) {
                    Text("写真を変更する")
                }
                .actionSheet(isPresented: $showActionSheet, content: {
                    ActionSheet(title: Text("選択してください"),
                                buttons: [
                                    .default(Text("カメラ"), action: {
                                        openCamera()
                                    }),
                                    .default(Text("フォトライブラリー"), action: {
                                        openAlbum()
                                    }),
                                    .cancel(Text("キャンセル"))
                                ])
                })
//                Button(<#PrimitiveButtonStyleConfiguration#>)
                Spacer()
            }
            HStack {
                Text("名前")
                TextField("おなまえ", text: $name)
            }
            HStack {
                Text("自己紹介")
                TextField("おなまえ", text: $name)
            }
            HStack {
                Text("best1")
//                Button<#PrimitiveButtonStyleConfiguration#>()
//                Button()
            }
            HStack {
                Text("best2")
//                Button()
//                Button()
            }
            HStack {
                Text("best3")
//                Button()
//                Button()
            }
            Spacer()
        }
    }
    
//    private func tapChangeImageButton(){
//        //カメラがフォトライブラリーどちらから画像を取得するか選択
//        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
//        //カメラが利用可能かチェック
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            //カメラを起動するための選択肢を定義
//            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action) in
//                //カメラを起動
//                let imagePickerController = UIImagePickerController()
//                imagePickerController.sourceType = .camera
//                imagePickerController.delegate = self
//                self.present(imagePickerController, animated: true, completion: nil)
//
//            })
//            alertController.addAction(cameraAction)
//        }
//        //フォトライブラリーが利用可能かチェック
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            //フォトライブラリーを起動するための選択肢を定義
//            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action) in
//                //カメラを起動
//                let imagePickerController = UIImagePickerController()
//                imagePickerController.sourceType = .photoLibrary
//                imagePickerController.delegate = self
//                self.present(imagePickerController, animated: true, completion: nil)
//
//            })
//            alertController.addAction(photoLibraryAction)
//        }
//        //キャンセルの選択肢を定義
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
//        alertController.addAction(cancelAction)
//        //iPadで落ちてしまう対策
//        alertController.popoverPresentationController?.sourceView = view
//        //選択肢を画面に表示
//        present(alertController, animated: true, completion: nil)
//    }
    
    private func openAlbum() {}
    private func openCamera() {}
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
