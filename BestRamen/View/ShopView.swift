//
//  ShopView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/13.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject private var viewModel: ShopViewModel
    init(id: String) {
        self.viewModel = ShopViewModel(id: id)
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 5) {
                Spacer().frame(height: 8)
                Text(viewModel.shop.shopName)
                    .font(.title2)
                    .offset(x: 10)
                Text(viewModel.shop.shopAddress)
                    .font(.body)
                    .offset(x: 10)
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 1), count: 3), spacing: 1) {
                    ForEach((1...10), id: \.self) { _ in
                        NavigationLink(
                            destination: PostView(id: "rLe8PhM4jmh9lNaPLGjb")) {
                            let imageEdge = (UIScreen.main.bounds.width - 2) / 3
                            Image("a")
                                .resizable()
                                .frame(width: imageEdge, height: imageEdge)
                        }
                    }
                }
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(id: "")
    }
}
