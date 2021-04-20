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
    @EnvironmentObject var googleDelegate: GoogleDelegate
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
            if googleDelegate.signedIn {
                userTabItem
                    .tabItem {
                        VStack {
                            Image("hito")
                            Text("マイページ")
                        }
                    }.tag(3)
            } else {
                signInItem
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
    
    private var userTabItem: some View {
        ZStack(alignment: .top) {
            NavigationView {
                //TODO: userID
                UserView(id: "U3a62ZBBH7ViN0CqnkWw").navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading:
                                            Button(action: {
                                                signOut()
                                                googleDelegate.signedIn = false
                                            }) { Text("ログアウト") })
            }
            
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor( .white)
            naviImageView
        }
    }
    
    private var signInItem: some View {
        ZStack(alignment: .top) {
            NavigationView {
                SignInView().navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor( .white)
            naviImageView
        }
    }
    
    private var naviImageView: some View {
        VStack {
            Spacer().frame(height: 12)
            Image("BestRamen")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/3)
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("ログアウト失敗")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
