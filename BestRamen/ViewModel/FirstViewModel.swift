//
//  FirstViewModel.swift
//  BestRamen
//
//  Created by maiko morisaki on 2021/02/06.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Foundation

protocol FirstViewModelDelegate: class {
    func reloadData()
}

class FirstViewModel {
    
    let model: FirstModel = FirstModel()
    var postsArry: [[String: String]] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    weak var delegate: FirstViewModelDelegate?
    
    func getList() {
        model.getList(complete: { [weak self] item in
            self?.postsArry = item
        })
    }
}
