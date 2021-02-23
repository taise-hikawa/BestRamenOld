//
//  PostModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

class PostModel {
    let db = Firestore.firestore()
    
    func fetch(id: String) {
        db.collection("posts")
            .document(id)
            .getDocument {(doc, err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    try? doc?.data(as: Post.self)
                }
            }
    }
    
    func delete(id: String) {
        db.collection("posts")
            .document(id)
            .delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
