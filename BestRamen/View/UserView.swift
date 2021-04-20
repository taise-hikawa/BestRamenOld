//
//  UserView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @ObservedObject private var viewModel: UserViewModel
    init(id: String) {
        self.viewModel = UserViewModel(id: id)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 8)
                headerView
                Text(viewModel.user.userName).offset(x: 10)
                Spacer().frame(height: 8)
                Text(viewModel.user.userProfile ?? "").offset(x: 10)
                favoriteRamenView
                ramenListView
            }
        }
        .navigationBarItems(leading:
                                Button(action: {
                                    viewModel.signOut()
                                    googleDelegate.signedIn = false
                                }) { Text("ログアウト") })
    }
    
    private var headerView: some View {
        HStack{
            Spacer().frame(width: 10)
            Image(uiImage: UIImage(data: viewModel.userImageData) ?? UIImage(named: "default")!)
                .resizable()
                .frame(width: 80, height: 80)
            Spacer()
            NavigationLink(
                destination: FollowListView(id: viewModel.user.userId, idType: .followedId),
                label: {
                    VStack(alignment: .center, spacing: 4) {
                        Text(viewModel.followedCount.description)
                        Text("フォロワー")
                    }
                }).buttonStyle(PlainButtonStyle())
            Spacer()
            NavigationLink(
                destination: FollowListView(id: viewModel.user.userId, idType: .followingId),
                label: {
                    VStack(alignment: .center, spacing: 4) {
                        Text(viewModel.followingCount.description)
                        Text("フォロー")
                    }
                }).buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    let ramens = ["best1:ラーメン屋", "best2:ラーメン屋", "best3:ラーメン屋"]
    private var favoriteRamenView: some View {
        List {
                    ForEach(0 ..< ramens.count) { index in
                        Text(ramens[index])
                    }
        }.frame(height: CGFloat(ramens.count) * 40)
    }
    
    private var ramenListView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 1), count: 3), spacing: 1) {
            ForEach(viewModel.postsArray, id: \.self) { item in
                NavigationLink(
                    destination: PostView(id: item.postId), label: {
                        let imageEdge = (UIScreen.main.bounds.width - 2) / 3
                        let uiImage = UIImage(data: viewModel.postImagesData[item.postId] ?? Data.init()) ?? UIImage(named: "noimage")!
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: imageEdge, height: imageEdge)
                    })
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(id: "")
    }
}
