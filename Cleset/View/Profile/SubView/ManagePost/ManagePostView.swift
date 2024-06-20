//
//  ManagePostView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI

enum ManagePostMenu: CaseIterable, MenuItemType {
    var id: Self { self }
    case myPost
    case favorite
    
    var displayName: String {
        switch self {
            case .myPost:
                "내가 작성한 글"
            case .favorite:
                "좋아요 누른 글"
        }
        
    }
    
    var image: Image {
        switch self {
            case .myPost:
                Image(systemName: "pencil")
            case .favorite:
                Image(systemName: "heart")
        }
    }
    
}

struct ManagePostView: View {
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "게시글 관리")
            
            VStack {
                ForEach(ManagePostMenu.allCases, id: \.self) { menu in
                    NavigationLink {
                        ManagePostList(
                            viewModel: ManagePostListViewModel(
                                container: container,
                                menu: menu
                            )
                        )
                    } label: {
                        MenuItem(menu: menu)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .listStyle(.inset)
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    ManagePostView()
}


