//
//  Shop.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct Shop: Codable {
    @DocumentID var id: String?
    let shopName: String
    let shopAddress: String
    let shopGeocode: GeoPoint
}
