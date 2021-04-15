//
//  ContentView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let isMe = false
    @EnvironmentObject var session: Session
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image("home")
                        Text("ホーム")
                    }
                }.tag(1)
            MapView()
                .tabItem {
                    VStack {
                        Image("search")
                        Text("見つける")
                    }
                }.tag(2)
//            if self.session.isLogin {
//                UserView()
//                    .tabItem {
//                        VStack {
//                            Image("hito")
//                            Text("マイページ")
//                        }
//                    }.tag(3)
//            } else {
                SignInView()
                    .tabItem {
                        VStack {
                            Image("hito")
                            Text("マイページ")
                        }
                    }.tag(3)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
