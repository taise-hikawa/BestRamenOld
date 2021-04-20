//
//  UserView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @ObservedObject private var viewModel: UserViewModel
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @State private var isMe: Bool = false
    let id: String
    init(id: String) {
        self.id = id
        self.viewModel = UserViewModel(id: id)
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 8)
                    headerView
                    Text(viewModel.user.userName)
                        .fontWeight(.bold).offset(x: 10).font(.title2)
                    Spacer().frame(height: 8)
                    Text(viewModel.user.userProfile ?? "").offset(x: 10)
                    if viewModel.isFollowing {
                        unFollowButton.hidden(isMe || !googleDelegate.signedIn)
                    } else {
                        followButton.hidden(isMe || !googleDelegate.signedIn)
                    }
                    favoriteRamenView
                    ramenListView
                }
            }
            postButton.offset(x: 25, y: 25)
                .hidden(!isMe)
        }
        .onAppear {
            isMe = googleDelegate.userId == id
            guard let currentUserId = googleDelegate.userId else { return }
            viewModel.checkFollowing(userId: id, currentUserId: currentUserId)
            
        }
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
    
    private var followButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if let id = googleDelegate.userId {
                    viewModel.follow(currentUserId: id)
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange)
                        .frame(width: 180, height: 30)
                    Text("フォローする")
                        .fontWeight(.bold)
                }
            }
            Spacer()
        }
    }
    
    private var unFollowButton: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.unFollow()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 180, height: 30)
                    Text("フォロー中")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
            }
            Spacer()
        }
    }
    
    private var postButton: some View {
        Button(action: {
            // Do something
        }) {
            ZStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 110, height: 110)
                Image("camera")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(id: "")
    }
}
