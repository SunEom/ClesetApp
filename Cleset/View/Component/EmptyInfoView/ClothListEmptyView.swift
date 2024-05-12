//
//  ClothListEmptyView.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

struct ClothListEmptyView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("hanger")
                .resizable()
                .frame(width: 100, height: 100)
            Group {
                Text("추가된 의상이 없습니다")
                Text("의상을 추가해보세요!")
            }
            .font(.system(size: 14, weight: .semibold))
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ClothListEmptyView()
}
