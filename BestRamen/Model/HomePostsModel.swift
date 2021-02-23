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
    public func fetchPosts(complete: @escaping ([Post]) -> ()) {
        Firestore.firestore().collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments{(querySnapshot, error) in
                if let result = querySnapshot?.documents.compactMap({
                    try? $0.data(as: Post.self)
                }) {
                complete(result)
            }
        }
    }
}

