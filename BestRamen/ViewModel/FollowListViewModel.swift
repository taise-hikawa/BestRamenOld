//
//  FollowListViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

class FollowListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var userArray: [Relationships] = []
    init(id: String, idType: FollowListView.FollowIdType) {
        fetchList(id: id, fieldName: idType.rawValue)
    }
    private func fetchList(id: String, fieldName: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationships.self,
                                                      collection: .relationships,
                                                      fieldName: fieldName,
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.userArray = value
                  })
            .store(in: &self.cancellables)
    }
//    private func fetchUser(id: String) {
//        FirebaseManeger().fetchDocument(responseType: User.self,
//                                        collection: .users,
//                                        id: id)
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: { value in
//                    self.user = value
//                  })
//            .store(in: &self.cancellables)
//    }
}
