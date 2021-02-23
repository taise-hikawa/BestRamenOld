//
//  Post.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation

public struct Post: Codable {
    let userId: Int?
    let userName: String?
    let shopId: Int?
    let shopName: String?
    let postId: Int?
    let postContent: String?
}
