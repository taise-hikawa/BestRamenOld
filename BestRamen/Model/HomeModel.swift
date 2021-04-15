//
//  HomeModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeModel {
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
    
    public func fetchPostImage(id: String) -> Data? {
        var imageData: Data?
        Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com").child("posts")
            .child("\(id).jpg")
            .getData(maxSize: 1024 * 1024 * 10, completion: { (data: Data?, error: Error?) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    imageData = data
                }
            })
        return imageData
    }
    
    public func fetchUserImage(id: String) -> Data? {
        var imageData: Data?
        Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com").child("users")
            .child("\(id).jpg")
            .getData(maxSize: 1024 * 1024 * 10, completion: { (data: Data?, error: Error?) in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    imageData = data
                }
            })
        return imageData
    }
    
}

