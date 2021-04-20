//
//  FollowListViewModel.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/20.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine
import SwiftUI

class FollowListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var userArray: [User] = []
    init(id: String, idType: FollowIdType) {
        fetchList(id: id, fieldName: idType.rawValue)
    }
    private func fetchList(id: String, fieldName: String) {
        FirebaseManeger().fetchDocumentsWithCondition(responseType: Relationship.self,
                                                      collection: .relationships,
                                                      fieldName: fieldName,
                                                      fieldValue: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    for item in value {
                        let isFollowingList = fieldName == FollowIdType.followingId.rawValue
                        let userId = isFollowingList ? item.followedId : item.followingId
                        self.fetchUsers(id: userId)
                    }
                  })
            .store(in: &self.cancellables)
    }
    private func fetchUsers(id: String) {
        FirebaseManeger().fetchDocument(responseType: User.self,
                                        collection: .users,
                                        id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    self.userArray.append(value)
                    self.fetchUserImage(id: id)
                  })
            .store(in: &self.cancellables)
    }
    
    private func fetchUserImage(id: String) {
        FirebaseManeger().fetchImage(child: .users, id: id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                    if let i = self.userArray.firstIndex(where: { $0.userId == id}) {
                        self.userArray[Int(i)].userImageData = value
                    }
                  })
            .store(in: &self.cancellables)
    }
}
