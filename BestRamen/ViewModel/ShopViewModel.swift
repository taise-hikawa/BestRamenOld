//
//  ShopViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/15.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

class ShopViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var shop: Shop?
    init(id: String) {
        fetchShop(id: id)
    }
    func fetchShop(id: String) {
        FirebaseManeger().fetchDocument(responseType: Shop.self,
                                      collection: .shops,
                                      id: "Bwl4B5VWZH58h3CPDD2G")//TODO: nilになってしまうことがあるので、値を入れておいた
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.shop = value
                  })
            .store(in: &self.cancellables)
    }
}
