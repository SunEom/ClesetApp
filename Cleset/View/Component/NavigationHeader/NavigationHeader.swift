//
//  NavigationHeader.swift
//  Cleset
//
//  Created by 엄태양 on 4/29/24.
//

import SwiftUI

struct NavigationHeader<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    var button: Content?
    var title: String = ""
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .foregroundStyle(Color.mainGreen)
            }
            Spacer()
            Text(title)
                .font(.system(size: 17, weight: .bold))
            Spacer()
            button
                .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .frame(minWidth: UIScreen.main.bounds.width, minHeight: 50, maxHeight: 50)
    }
}

#Preview {
    NavigationHeader<AnyView>(title: "타이틀")
}
