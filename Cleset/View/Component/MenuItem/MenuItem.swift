//
//  MenuItem.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

protocol MenuItemType {
    var displayName: String { get }
    var image: Image { get }
}

struct MenuItem: View {
    let menu: MenuItemType
    var body: some View {
        HStack(spacing: .zero) {
            menu.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.trailing, 10)
                .frame(width: 35)
                
            Text(menu.displayName)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.bk)
        .padding(.horizontal, 20)
        .frame(height: 40)
        .background(Color.background)
    }
}

#Preview {
    MenuItem(menu: ProfileMenu.editProfile)
}
