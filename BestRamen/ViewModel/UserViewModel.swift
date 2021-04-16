//
//  UserViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/16.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

class UserViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User?
    init(id: String) {
        fetchUser(id: id)
    }
    func fetchUser(id: String) {
        FirebaseManeger().fetchDocument(responseType: User.self,
                                      collection: .users,
                                      id: "Bwl4B5VWZH58h3CPDD2G")//TODO: nilになってしまうことがあるので、値を入れておいた
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.user = value
                  })
            .store(in: &self.cancellables)
    }
}
