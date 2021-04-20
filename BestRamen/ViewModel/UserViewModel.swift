//
//  UserViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/16.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine
import FirebaseAuth

class UserViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User = User(id: "", userName: "", userProfile: "")
    @Published var postsArray: [Post] = []
    @Published var postImagesData: [String: Data] = [:]
    @Published var userImageData: Data = Data.init()
    @Published var followingCount: Int = 0
    @Published var followedCount: Int = 0
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
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationships.self,
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
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationships.self,
                                                      collection: .relationships,
                                                      fieldName: FollowIdType.followedId.rawValue,
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.followedCount = value.count
                  })
            .store(in: &self.cancellables)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("ログアウト失敗")
        }
    }
}
