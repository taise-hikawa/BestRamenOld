//
//  Post.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import Foundation
import FirebaseFirestoreSwift

public struct Post: Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    var userName: String
    let shopId: String
    let shopName: String
    let postContent: String
    var userImageData: Data? = Data.init()
    var postImageData: Data? = Data.init()
}

extension Post {
    var postId: String { id ?? "" }
}
