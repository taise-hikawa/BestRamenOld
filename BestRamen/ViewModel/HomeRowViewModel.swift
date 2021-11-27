//
//  HomeRowViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine
import SwiftUI

class HomeRowViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var post: Post
    init(post: Post) {
        self.post = post
        fetchPostImage(id: post.postId)
        fetchUserImage(id: post.userId)
    }
    private func fetchPostImage(id: String) {
        FirebaseManeger().fetchImage(child: .posts, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.post.postImageData = value
                  })
            .store(in: &self.cancellables)
    }
    private func fetchUserImage(id: String) {
        FirebaseManeger().fetchImage(child: .users, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.post.userImageData = value
                  })
            .store(in: &self.cancellables)
    }
}
