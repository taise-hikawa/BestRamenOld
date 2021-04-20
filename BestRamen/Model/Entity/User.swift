//
//  User.swift
//  BestRamen
//
//  Created by Taisei Hikawa on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import FirebaseFirestoreSwift

public struct User: Codable {
    @DocumentID var id: String?
    let userName: String
    let userProfile: String?
    var userImageData: Data? = Data.init()
}
extension User {
    var userId: String { id ?? "" }
}
