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
        VStack(alignment: .leading,spacing: 10) {
            Spacer().frame(height: 2)
            NavigationLink(
                destination: UserView(id: viewModel.post.userId)) {
                HStack(spacing: 7) {
                    Image(uiImage: UIImage(data: viewModel.userImageData) ?? UIImage(named: "default")!)
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text(viewModel.post.userName)
                    Spacer()
                }
                .offset(x: 6)
            }.buttonStyle(PlainButtonStyle())
            .navigationViewStyle(StackNavigationViewStyle())
            Image(uiImage: UIImage(data: viewModel.postImageData) ?? UIImage(named: "noimage")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            NavigationLink(destination: ShopView(id: viewModel.post.shopId)) {
                Text(viewModel.post.shopName)
                    .offset(x: 6)
            }.buttonStyle(PlainButtonStyle())
            Text(viewModel.post.postContent)
                .offset(x: 6)
            Spacer()
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(id: "")
    }
}
