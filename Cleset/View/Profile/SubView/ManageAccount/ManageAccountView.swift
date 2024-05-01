//
//  ManageAccountView.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import SwiftUI



struct ManageAccountView: View {
    enum ManageAccountMenu: CaseIterable {
        case logout
        case deleteAccount
        
        var displayName: String {
            get {
                switch self {
                    case .logout:
                        "로그아웃"
                    case .deleteAccount:
                        "계정탈퇴"
                }
            }
        }
        
    }
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            NavigationHeader<AnyView>(title: "계정 관리")
            ForEach(ManageAccountMenu.allCases, id: \.self) { menu in
                VStack(spacing: .zero) {
                    switch menu {
                        case .logout:
                            Button {
                                authViewModel.send(.logout)
                            } label: {
                                ManageAccountMenuItem(menu: menu)
                            }
                        case .deleteAccount:
                            NavigationLink {
                                DeleteAccountView(viewModel: DeleteAccountViewModel(container: container))
                            } label: {
                                ManageAccountMenuItem(menu: menu)
                                    .foregroundStyle(Color.red)
                            }
                    }
                    
                    Rectangle().fill(Color.gray0)
                        .frame(height: 1)
                }
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
        
    struct ManageAccountMenuItem: View {
        let menu: ManageAccountMenu
        var body: some View {
            HStack(spacing: .zero) {
                Text(menu.displayName)
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background(Color.white)
        }
    }

}


#Preview {
    ManageAccountView()
}
