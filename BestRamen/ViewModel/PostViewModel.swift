//
//  PostViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

class PostViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var post: Post?
    init(id: String) {
        fetchPost(id: id)
    }
    func fetchPost(id: String) {
        FirebaseManeger().fetchDocument(responseType: Post.self,
                                      collection: .posts,
                                      id: "rLe8PhM4jmh9lNaPLGjb") //TODO: nilになってしまうことがあるので、値を入れておいた
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.post = value
                  })
            .store(in: &self.cancellables)
    }
}
