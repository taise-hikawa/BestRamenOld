//
//  FollowListView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI
public enum FollowIdType: String {
    case followingId, followedId
}

struct FollowListView: View {
    @ObservedObject private var viewModel: FollowListViewModel
    init(id: String, idType: FollowIdType) {
        self.viewModel = FollowListViewModel(id: id,idType: idType)
    }
    var body: some View {
        List {
            ForEach(viewModel.userArray, id: \.self) { item in
                NavigationLink(destination: UserView(id: item.userId)) {
                    HStack(spacing: 8) {
                        let img = UIImage(data: item.userImageData ?? Data.init()) ?? UIImage(named: "default")!
                        Image(uiImage: img)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(item.userName)
                            .font(.body)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView(id: "", idType: .followedId)
    }
}
