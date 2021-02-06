//
//  FirstModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation
import Firebase

class FirstModel {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    
    func getList(complete: @escaping ([[String: String]]) -> ()) {
        var postsAry: [[String: String]] = []
        db.collection("posts").order(by: "createdAt", descending: true).getDocuments{(querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    var postDic:Dictionary<String, String> = [:]
                    postDic["userName"] = document.data()["userName"] as? String
                    postDic["userId"] = document.data()["userId"] as? String
                    postDic["shopName"] = document.data()["shopName"] as? String
                    postDic["shopId"] = document.data()["shopId"] as? String
                    postDic["postContent"] = document.data()["postContent"] as? String
                    postDic["postId"] = document.documentID
                    postsAry.append(postDic)
                }
                complete(postsAry)
            }
        }
    }
}
