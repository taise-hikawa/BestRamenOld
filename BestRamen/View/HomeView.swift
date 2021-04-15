//
//  HomeView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel()
    var body: some View {
//        NavigationView {
            List(viewModel.postsArray, id: \.self) { item in
                NavigationLink(destination: PostView()) {
                    HomeRow.init(post: item,
                                 postImgData: $viewModel.postImagesDic[item.postId],
                                 userImgData: $viewModel.userImagesDic[item.userId])
                        .frame(height: 300)
                        .clipped()
                        .listRowInsets(EdgeInsets())
                }
            }
//        }
//        .navigationBarTitle("タイトル", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
