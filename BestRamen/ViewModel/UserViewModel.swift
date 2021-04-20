//
//  UserViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/16.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @Published var user: User = User(id: "", userName: "", userProfile: "")
    @Published var postsArray: [Post] = []
    @Published var postImagesData: [String: Data] = [:]
    @Published var userImageData: Data = Data.init()
    @Published var followingCount: Int = 0
    @Published var followedCount: Int = 0
    @Published var isFollowing: Bool = false
    var relationshipId: String?
    init(id: String) {
        fetchUser(id: id)
        fetchPosts(id: id)
        fetchUserImage(id: id)
        fetchFollowingCount(id: id)
        fetchFollowedCount(id: id)
    }
    
    private func fetchUser(id: String) {
        FirebaseManeger().fetchDocument(responseType: User.self,
                                        collection: .users,
                                        id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.user = value
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchPosts(id: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Post.self,
                                                      collection: .posts,
                                                      fieldName: "userId",
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postsArray = value
                    for item in value {
                        self.fetchPostImages(id: item.postId)
                    }
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchPostImages(id: String) {
        FirebaseManeger().fetchImage(child: .posts, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postImagesData[id] = value
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchUserImage(id: String) {
        FirebaseManeger().fetchImage(child: .users, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.userImageData = value
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchFollowingCount(id: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationship.self,
                                                      collection: .relationships,
                                                      fieldName: FollowIdType.followingId.rawValue,
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.followingCount = value.count
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchFollowedCount(id: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationship.self,
                                                      collection: .relationships,
                                                      fieldName: FollowIdType.followedId.rawValue,
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.followedCount = value.count
                  })
            .store(in: &self.cancellables)
    }
    
    func checkFollowing(userId: String, currentUserId: String) {
        FirebaseManeger().fetchDocumentsWithTwoCondition(responseType: Relationship.self,
                                                         collection: .relationships,
                                                         firstField: FollowIdType.followedId.rawValue,
                                                         firstFieldValue: userId,
                                                         secondField: FollowIdType.followingId.rawValue,
                                                         secondFieldValue: currentUserId)
            .sink(receiveCompletion: { _ in },
            receiveValue: { value in
                self.isFollowing = value.count == 0 ? false : true
                self.relationshipId = value.first?.relationshipId
            })
            .store(in: &self.cancellables)
    }
    
    func follow(currentUserId: String) {
        let data = Relationship.init(createdAt: Timestamp.init(),followingId: currentUserId, followedId: user.userId)
        FirebaseManeger().addDocument(data: data,
                                      collection: .relationships)
            .sink(receiveCompletion: { _ in },
            receiveValue: { value in
                self.relationshipId = value
                self.isFollowing = true
                self.fetchFollowingCount(id: self.user.userId)
                self.fetchFollowedCount(id: self.user.userId)
            })
            .store(in: &self.cancellables)
    }
    
    func unFollow() {
        guard let id = relationshipId else { return }
        FirebaseManeger().deleteDocument(collection: .relationships,
                                         id: id)
            .sink(receiveCompletion: { _ in
                self.relationshipId = nil
                self.isFollowing = false
                self.fetchFollowingCount(id: self.user.userId)
                self.fetchFollowedCount(id: self.user.userId)
            },
                  receiveValue: {})
            .store(in: &self.cancellables)
    }
}
