//
//  UserView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                headerView
                Text("名前").offset(x: 10)
                Spacer().frame(width: 8)
                Text("自己紹介").offset(x: 10)
                favoriteRamenView
                ramenListView
            }
        }
    }
    
    var headerView: some View {
        HStack{
            Spacer().frame(width: 10)
            Image("a")
                .resizable()
                .frame(width: 80, height: 80)
            Spacer()
            NavigationLink(
                destination: FollowListView(),
                label: {
                    VStack(alignment: .center, spacing: 4) {
                        Text("0")//TODO: ViewModel実装後
                        Text("フォロワー")
                    }
                }).buttonStyle(PlainButtonStyle())
            Spacer()
            NavigationLink(
                destination: FollowListView(),
                label: {
                    VStack(alignment: .center, spacing: 4) {
                        Text("0")//TODO: ViewModel実装後
                        Text("フォロー")
                    }
                }).buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    let ramens = ["best1:ラーメン屋", "best2:ラーメン屋", "best3:ラーメン屋"]
    var favoriteRamenView: some View {
        List {
                    ForEach(0 ..< ramens.count) { index in
                        Text(ramens[index])
                    }
        }.frame(height: CGFloat(ramens.count) * 40)
    }
    
    var ramenListView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 1) {
            ForEach((1...10), id: \.self) { _ in
                NavigationLink(
                    destination: PostView()) {
                    Image("a")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/3 - 2, height: UIScreen.main.bounds.width/3 - 2)
                }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
