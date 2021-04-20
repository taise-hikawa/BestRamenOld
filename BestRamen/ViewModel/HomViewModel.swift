//
//  HomePostsViewModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//
import Foundation
import Combine

internal protocol HomeViewModelInputs {}
internal protocol HomeViewModelOutputs {}

class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var postsArray: [Post] = []
    init() {
        fetchPosts()
    }
    
    private func fetchPosts() {
        FirebaseManeger().fetchDocuments(responseType: Post.self,
                                       collection: .posts)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postsArray = value
                  })
            .store(in: &self.cancellables)

    }
}
