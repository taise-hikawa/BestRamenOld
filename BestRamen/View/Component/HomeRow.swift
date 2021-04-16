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
    @Binding var postImgData: Data?
    @Binding var userImgdata: Data?
    let uiImage = UIImage(named: "a")!
    init(post: Post, postImgData: Binding<Data?>, userImgData: Binding<Data?>) {
        self.post = post
        self._postImgData = postImgData
        self._userImgdata = userImgData
    }
    var body: some View {
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Image(uiImage: uiImage)
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
