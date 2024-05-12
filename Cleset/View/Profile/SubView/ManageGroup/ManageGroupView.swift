//
//  ManageGroupView.swift
//  Cleset
//
//  Created by 엄태양 on 4/30/24.
//

import SwiftUI

enum ManageGroupMenu: MenuItemType, CaseIterable {
    case manageGroupList
    case manageClothByGroup
    
    var displayName: String {
        switch self {
            case .manageGroupList:
                "그룹 목록 관리"
                
            case .manageClothByGroup:
                "그룹별 의상 관리"
        }
    }
    
    var image: Image {
        switch self {
            case .manageGroupList:
                Image("manageGroupList")
            case .manageClothByGroup:
                Image("manageClothByGroup")
        }
    }
}

struct ManageGroupView: View {
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "그룹 관리")
            
            ForEach(ManageGroupMenu.allCases, id: \.self) { menu in
                NavigationLink {
                    switch menu {
                        case .manageGroupList:
                            ManageGroupList(
                                viewModel: ManageGroupListViewModel(
                                    container: container
                                )
                            )
                        case .manageClothByGroup:
                            ManageClothByGroupView(
                                viewModel: ManageClothByGroupViewModel(
                                    container: container
                                )
                            )
                    }
                } label: {
                    MenuItem(menu: menu)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    ManageGroupView()
}
