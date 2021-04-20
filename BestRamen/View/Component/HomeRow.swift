//
//  HomeRow.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct HomeRow: View {
    private let post: Post
    @ObservedObject private var viewModel: HomeRowViewModel
    init(post: Post) {
        self.post = post
        self.viewModel = HomeRowViewModel(post: post)
    }
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: viewModel.postImageData) ?? UIImage(named: "noimage")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Image(uiImage: UIImage(data: viewModel.userImageData) ?? UIImage(named: "default")!)
                        .resizable()
                        .frame(maxWidth: 40, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text(post.userName)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, height: 50)
                Spacer()
                Text(post.shopName)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.title3)
            }
        }
    }
}
