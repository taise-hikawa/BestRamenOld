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
    
    let model: HomeModel = HomeModel()
    @Published var postsArray: [Post] = []
    @Published var postImagesDic: [String: Data] = [:] //本当はPostの中に持たせたい
    @Published var userImagesDic: [String: Data] = [:] //本当はPostの中に持たせたい
    init() {
        fetchPosts()
    }
    private func fetchPosts() {
        model.fetchPosts(complete: { [weak self] item in
            self?.postsArray = item
            self?.fetchPostImages()
            self?.fetchUserImages()
        })
    }
    
    private func fetchPostImages() {
        postsArray.forEach {
            postImagesDic[$0.postId] = model.fetchPostImage(id: $0.postId)
        }
    }
    
    private func fetchUserImages() {
        postsArray.forEach {
            postImagesDic[$0.userId] = model.fetchUserImage(id: $0.userId)
        }
    }
}
