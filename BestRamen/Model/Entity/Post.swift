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
    let userName: String
    let shopId: String
    let shopName: String
    let postContent: String
    
    init(id: String, userId: String, userName: String, shopId: String, shopName: String, postContent: String) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.shopId = shopId
        self.shopName = shopName
        self.postContent = postContent
    }
}

extension Post {
    var postId: String { id ?? "" }
}
