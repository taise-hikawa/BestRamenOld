//
//  Relationships.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Relationship: Codable, Hashable {
    @DocumentID var id: String?
    let createdAt: Timestamp
    let followingId: String
    let followedId: String
}

extension Relationship {
    var relationshipId: String { id ?? "" }
}
