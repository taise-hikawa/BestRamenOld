//
//  AppState.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/14.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import Combine

final class AppState: ObservableObject {
    @Published var isLogin = false
}
