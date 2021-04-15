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
            ZStack(alignment: .top) {
                NavigationView { HomeView() }.accentColor( .white)
                naviImageView
            }
            .tabItem {
                VStack {
                        Image("home")
                        Text("ホーム")
                    }
                }.tag(1)
            ZStack(alignment: .top) {
                NavigationView { MapView() }.accentColor( .white)
                naviImageView
            }
                .tabItem {
                    VStack {
                        Image("search")
                        Text("見つける")
                    }
                }.tag(2)
            
            //            if self.session.isLogin {
            ZStack(alignment: .top) {
                NavigationView { UserView() }.accentColor( .white)
                naviImageView
            }
                .tabItem {
                    VStack {
                        Image("hito")
                        Text("マイページ")
                    }
                }.tag(3)
            
            //            } else {
            //               NavigationView { SignInView() }
            //                    .tabItem {
            //                        VStack {
            //                            Image("hito")
            //                            Text("マイページ")
            //                        }
            //                    }.tag(3)
            //            }
        }
    }
    
    var naviImageView: some View {
        Image("BestRamen")
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width/2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
