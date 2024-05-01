//
//  ProfileView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI

enum ProfileMenu: CaseIterable {
    case editProfile
    case manageGroup
    case managePost
    case manageAccount
    
    var displayName: String {
        get {
            switch self {
                case .editProfile:
                    return "내 정보 수정"
                case .manageGroup:
                    return "그룹 관리"
                case .managePost:
                    return "게시글 관리"
                case .manageAccount:
                    return "계정 관리"
            }
        }
    }
    
    var imageName: String {
        get {
            switch self {
                case .editProfile:
                    "editProfile"
                case .manageGroup:
                    "manageGroup"
                case .managePost:
                    "managePost"
                case .manageAccount:
                    "manageAccount"
            }
        }
    }
}

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    profileHeader
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                    
                    profileMenuList
                    
                    Spacer()
                }
            }
            .background(Color.white)
        }
    }
    
    var profileHeader: some View {
        
        HStack(spacing: .zero) {
            
            Image(viewModel.userData.genderImageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 25, height: 25)
                .fontWeight(.heavy)
                .foregroundStyle(Color.mainGreen)
                .padding(.trailing, 10)
            
            
            Text(viewModel.userData.nickname)
                .font(.system(size: 20, weight: .semibold))
                .padding(.trailing, 3)
            
            Text("(\(viewModel.userData.age))")
                .font(.system(size: 15))
            
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }
    
    var profileMenuList: some View {
        VStack {
            ForEach(ProfileMenu.allCases, id: \.self) { menu in
                NavigationLink {
                    switch menu {
                        case .editProfile:
                            EditProfileView(viewModel: EditProfileViewModel(container: container))
                            
                        case .manageGroup:
                            ManageGroupView(viewModel: ManageGroupViewModel(container: container))
                            
                        case .managePost:
                            ManagePostView(viewModel: ManagePostViewModel(container: container))
                            
                        case .manageAccount:
                            ManageAccountView()
                    }
                } label: {
                    ProfileMenuItem(menu: menu)
                }
                .onDisappear {
                    viewModel.send(.updateUserData)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    struct ProfileMenuItem: View {
        let menu: ProfileMenu
        var body: some View {
            HStack(spacing: .zero) {
                Image(menu.imageName)
                    .padding(.trailing, 10)
                Text(menu.displayName)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background(Color.white)
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}

