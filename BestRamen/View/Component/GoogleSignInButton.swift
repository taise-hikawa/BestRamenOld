//
//  GoogleSignInButton.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//


import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct GoogleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        return button
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
