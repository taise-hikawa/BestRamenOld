//
//  Session.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/14.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

final class Session: ObservableObject {
    @Published var isLogin: Bool
    @Published var user: User?
    
    init(isLogin: Bool = false, user: User? = nil) {
        self.isLogin = isLogin
        self.user = user
    }
}
