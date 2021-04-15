//
//  PostView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 10) {
            NavigationLink(
                destination: UserView()) {
                HStack(spacing: 7) {
                    Image("default")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("hikawa")
                    Spacer()
                }
                .offset(x: 6)
            }
            Image("a")
                .resizable()
                .aspectRatio(contentMode: .fit)
            NavigationLink(destination: ShopView()) {
                Text("店の名前")
                    .offset(x: 6)
            }
            Text("投稿内容")
                .offset(x: 6)
            Spacer()
        }
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
