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
    case posts, shops, users, relationships
}
public enum Child: String {
    case posts, users
}

final class FirebaseManeger {
    let db : Firestore
    let storage = Storage.storage().reference(forURL: "gs://bestramen-90259.appspot.com")
    init() {
        db = Firestore.firestore()
    }
    // MARK: FireStore
    func fetchDocuments<T: Codable>(responseType:T.Type,
                                    collection: Collection)
    -> AnyPublisher<[T], Error> {
        Future<[T], Error> { promise in
            self.db.collection(collection.rawValue)
                .order(by: "createdAt", descending: true)
                .getDocuments{(querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    if let result = querySnapshot?.documents.compactMap({
                        try? $0.data(as: responseType.self)
                    }) {
                        promise(.success(result))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchDocumentsWithCondition<T: Codable>(responseType:T.Type,
                                                 collection: Collection,
                                                 fieldName: String,
                                                 fieldValue: String)
    -> AnyPublisher<[T], Error> {
        Future<[T], Error> { promise in
            self.db.collection(collection.rawValue)
                .whereField(fieldName, isEqualTo: fieldValue)
                .order(by: "createdAt", descending: true)
                .getDocuments{(querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    if let result = querySnapshot?.documents.compactMap({
                        try? $0.data(as: responseType.self)
                    }) {
                        promise(.success(result))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchDocumentsWithTwoCondition<T: Codable>(responseType:T.Type,
                                                 collection: Collection,
                                                 firstField: String,
                                                 firstFieldValue: String,
                                                 secondField: String,
                                                 secondFieldValue: String)
    -> AnyPublisher<[T], Error> {
        Future<[T], Error> { promise in
            self.db.collection(collection.rawValue)
                .whereField(firstField, isEqualTo: firstFieldValue)
                .whereField(secondField, isEqualTo: secondFieldValue)
                .order(by: "createdAt", descending: true)
                .getDocuments{(querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    if let result = querySnapshot?.documents.compactMap({
                        try? $0.data(as: responseType.self)
                    }) {
                        promise(.success(result))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchDocument<T: Codable>(responseType:T.Type,
                                   collection: Collection,
                                   id: String) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            self.db.collection(collection.rawValue)
                .document(id)
                .getDocument {(snapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    if let result = try? snapshot?.data(as: responseType.self) {
                        promise(.success(result))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func addDocument<T: Codable>(data: T, collection: Collection) -> AnyPublisher<String, Error>  {
        var ref: DocumentReference?
        return Future<String, Error> { promise in
            do {
                ref = try self.db.collection(collection.rawValue)
                    .addDocument(from: data) { error in
                        if let error = error {
                            promise(.failure(error))
                        }
                        if let id = ref?.documentID {
                            promise(.success(id))
                        }
                    }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteDocument(collection: Collection, id: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.db.collection(collection.rawValue)
                .document(id)
                .delete() { error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    promise(.success(()))
                }
        }.eraseToAnyPublisher()
    }
    
    // MARK: FirebaseStorage
    
    func fetchImage(child: Child, id: String) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { promise in
            self.storage.child(child.rawValue)
                .child(id + ".jpg")
                .getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    if let imageData = data {
                        promise(.success(imageData))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
