//
//  PlayerIconView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//

import SwiftUI

struct PlayerIconView: View {
    var nameImage: String
    var geo: GeometryProxy
    var body: some View {
        Image(nameImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: geo.size.width / 5)
    }
}
