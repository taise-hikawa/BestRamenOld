//
//  PostView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct PostView: View {
    @ObservedObject private var viewModel: PostViewModel
    init(id: String) {
        self.viewModel = PostViewModel(id: id)
    }
    var body: some View {
        if let post = viewModel.post {
        VStack(alignment: .leading,spacing: 10) {
            NavigationLink(
                destination: UserView()) {
                HStack(spacing: 7) {
                    Image("default")//TODO: 画像Storageから
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text(post.userName)
                    Spacer()
                }
                .offset(x: 6)
            }.buttonStyle(PlainButtonStyle())
            Image("a") //TODO: 画像Storageから
                .resizable()
                .aspectRatio(contentMode: .fit)
            NavigationLink(destination: ShopView()) {
                Text(post.shopName)
                    .offset(x: 6)
            }.buttonStyle(PlainButtonStyle())
            Text(post.postContent)
                .offset(x: 6)
            Spacer()
        }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(id: "")
    }
}
