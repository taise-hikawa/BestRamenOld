//
//  Relationships.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

public struct Relationships: Codable, Hashable {
    let followingId: String
    let followingName: String
    let followedId: String
    let followedName: String
}

