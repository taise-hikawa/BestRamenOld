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
    init(id: String) {
        fetchUser(id: id)
        fetchPosts(id: id)
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
