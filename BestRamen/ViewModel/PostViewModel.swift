//
//  PostViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine
import SwiftUI

class PostViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var post: Post = Post(id: "", userId: "", userName: "", shopId: "", shopName: "", postContent: "")
    @Published var postImageData: Data = Data.init()
    @Published var userImageData: Data = Data.init()
    init(id: String) {
        fetchPost(id: id)
    }
    func fetchPost(id: String) {
        FirebaseManeger().fetchDocument(responseType: Post.self,
                                      collection: .posts,
                                      id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.post = value
                    self.fetchPostImage(id: value.postId)
                    self.fetchUserImage(id: value.userId)
                  })
            .store(in: &self.cancellables)
    }
    private func fetchPostImage(id: String) {
        FirebaseManeger().fetchImage(child: .posts, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postImageData = value
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
}
