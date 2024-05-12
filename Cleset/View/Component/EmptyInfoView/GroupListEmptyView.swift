//
//  GroupListEmptyView.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import SwiftUI

struct GroupListEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("emptyGroup")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("생성된 그룹이 없습니다")
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom, 10)
    }
}

#Preview {
    GroupListEmptyView()
}
