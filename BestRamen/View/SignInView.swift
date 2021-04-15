//
//  SignInView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {
    var body: some View {
        VStack(spacing: 100){
            Text("ログインされていません")
                .fontWeight(.bold)
            GoogleSignInButton()
                .frame(width: 150 ,height: 40)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
