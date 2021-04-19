//
//  ContentView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    let isMe = false
    @EnvironmentObject var session: Session
    var body: some View {
        TabView {
            homeTabItem
                .tabItem {
                    VStack {
                        Image("home")
                        Text("ホーム")
                    }
                }.tag(1)
            searchTabItem
                .tabItem {
                    VStack {
                        Image("search")
                        Text("見つける")
                    }
                }.tag(2)
            if GoogleDelegate().signedIn,
               let userId = Auth.auth().currentUser?.uid {
                ZStack(alignment: .top) {
                    NavigationView {
                        //TODO: userID
                        UserView(id: userId).navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .accentColor( .white)
                    naviImageView
                }
                .tabItem {
                    VStack {
                        Image("hito")
                        Text("マイページ")
                    }
                }.tag(3)
            } else {
                NavigationView { SignInView().navigationBarTitleDisplayMode(.inline) }
                    .tabItem {
                        VStack {
                            Image("hito")
                            Text("マイページ")
                        }
                    }.tag(3)
            }
        }
    }
    private var homeTabItem: some View {
        ZStack(alignment: .top) {
            NavigationView {
                HomeView().navigationBarTitleDisplayMode(.inline)
            }
            .accentColor( .white)
            //エラーメッセージ回避 https://developer.apple.com/forums/thread/668433
            .navigationViewStyle(StackNavigationViewStyle())
            naviImageView
        }
    }
    
    private var searchTabItem: some View {
        ZStack(alignment: .top) {
            NavigationView {
                MapView().navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor( .white)
            naviImageView
        }
    }
    
    private var naviImageView: some View {
        VStack {
            Spacer().frame(height: 6)
            Image("BestRamen")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
