//
//  PostViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/02/23.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation
import Firebase

class PostViewModel {
    
    let model: PostModel = PostModel()
    public let currentUser = Auth.auth().currentUser?.description
    func deletePost(id: String) {
        model.delete(id: id)
    }
}
