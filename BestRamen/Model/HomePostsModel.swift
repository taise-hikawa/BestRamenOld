//
//  HomePostsModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomePostsModel {
    private let db = Firestore.firestore()
    
    public func fetchPosts(complete: @escaping ([Post]) -> ()) {
        var postsAry: [[String: String]] = []
        db.collection("posts").order(by: "createdAt", descending: true).getDocuments{(querySnapshot, error) in
            if let result = querySnapshot?.documents.compactMap({ try? $0.data(as: Post.self) }){
                complete(result)
            }
//            complete(dic)
//            print(dic)
        
            
//            if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    var postDic:Dictionary<String, String> = [:]
//                    postDic["userName"] = document.data()["userName"] as? String
//                    postDic["userId"] = document.data()["userId"] as? String
//                    postDic["shopName"] = document.data()["shopName"] as? String
//                    postDic["shopId"] = document.data()["shopId"] as? String
//                    postDic["postContent"] = document.data()["postContent"] as? String
//                    postDic["postId"] = document.data()["postId"] as? String
//                    postsAry.append(postDic)
//                }
//                complete(postsAry)
//            }
        }
    }
}
