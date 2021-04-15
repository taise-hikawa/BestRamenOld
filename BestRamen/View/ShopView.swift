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
        if let shop = viewModel.shop {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(shop.shopName)
                        .font(.title2)
                    Text(shop.shopAddress)
                        .font(.body)
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 1) {
                        ForEach((1...10), id: \.self) { _ in
                            NavigationLink(
                                destination: PostView(id: "")) {
                                Image("a")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width/3 - 2, height: UIScreen.main.bounds.width/3 - 2)
                            }
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
