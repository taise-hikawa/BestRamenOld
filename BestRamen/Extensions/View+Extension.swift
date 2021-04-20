//
//  View+Extension.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/21.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI
struct Hidden: ViewModifier {
    let hidden: Bool

    func body(content: Content) -> some View {
        VStack {
            if !hidden {
                content
            }
        }
    }
}
extension View {
    func hidden(_ isHidden: Bool) -> some View {
        ModifiedContent(content: self, modifier: Hidden(hidden: isHidden))
    }
}
