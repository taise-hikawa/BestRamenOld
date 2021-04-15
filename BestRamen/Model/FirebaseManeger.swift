//
//  FirebaseManeger.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/03/31.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import Combine
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

public enum Collection: String {
    case posts, shops, users
}

final class FirebaseManeger {
    // MARK: FireStore
    static func fetchDocuments<T: Codable>(responseType:T.Type, collection: Collection) -> AnyPublisher<[T], NSError> {
        Future<[T], NSError> { promise in
            Firestore.firestore().collection(collection.rawValue)
            .order(by: "createdAt", descending: true)
            .getDocuments{(querySnapshot, error) in
                if let error = error {
                    print(error)
                }
                if let result = querySnapshot?.documents.compactMap({
                    try? $0.data(as: responseType.self)
                }) {
                    promise(.success(result))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func fetchDocument<T: Codable>(responseType:T.Type, collection: Collection, id: String) -> Future<T, NSError> {
        return Future<T, NSError> { promise in
            Firestore.firestore().collection(collection.rawValue)
                .document(id)
                .getDocument{(document, error) in
                    if let error = error {
                        print(error)
                    }
                    if let result = try? document?.data(as: responseType.self) {
                        promise(.success(result))
                    }
                }
        }
    }
    // MARK: FirebaseStorage
}
