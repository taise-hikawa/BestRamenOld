//
//  ShopViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/15.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine
import FirebaseFirestore

class ShopViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var shop: Shop = Shop(id: "", shopName: "", shopAddress: "", shopGeocode: GeoPoint(latitude: 0.0, longitude: 0.0))
    @Published var postsArray: [Post] = []
    @Published var postImagesData: [String: Data] = [:]
    init(id: String) {
        fetchShop(id: id)
        fetchPosts(id: id)
    }
    private func fetchShop(id: String) {
        FirebaseManeger().fetchDocument(responseType: Shop.self,
                                        collection: .shops,
                                        id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.shop = value
                  })
            .store(in: &self.cancellables)
    }
    private func fetchPosts(id: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Post.self,
                                                      collection: .posts,
                                                      fieldName: "shopId",
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postsArray = value
                    for item in value {
                        self.fetchPostImages(id: item.postId)
                    }
                  })
            .store(in: &self.cancellables)
    }
    private func fetchPostImages(id: String) {
        FirebaseManeger().fetchImage(child: .posts, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.postImagesData[id] = value
                  })
            .store(in: &self.cancellables)
    }
}
