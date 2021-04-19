//
//  FollowListViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

class FollowListViewModel: ObservableObject {
    @Published var userArray: [User] = []
    init(id: String, idType: FollowListView.FollowIdType) {
        fetchList(id: id, fieldName: idType.rawValue)
    }
    private func fetchList(id: String, fieldName: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: User.self,
                                                      collection: .relationships,
                                                      fieldName: fieldName,
                                                      fieldValue: id)
    }
}
