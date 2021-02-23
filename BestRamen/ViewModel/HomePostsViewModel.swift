//
//  HomePostsViewModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation

protocol HomePostsViewModelDelegate: class {
    func reloadData()
}

class HomePostsViewModel {
    
    let model: HomePostsModel = HomePostsModel()
    var postsArry: [Post] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    weak var delegate: HomePostsViewModelDelegate?
    
    func fetchPosts() {
        model.fetchPosts(complete: { [weak self] item in
            self?.postsArry = item
        })
    }
}
