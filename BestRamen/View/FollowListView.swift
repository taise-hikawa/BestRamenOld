//
//  FollowListView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct FollowListView: View {
    var body: some View {
        List {
            ForEach(0..<3) {_ in
                NavigationLink(destination: UserView()) {
                    HStack(spacing: 8) {
                        Image("default")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("お名前")
                            .font(.body)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView()
    }
}
