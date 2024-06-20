//
//  ProfileView.swift
//  Cleset
//
//  Created by 엄태양 on 4/25/24.
//

import SwiftUI



enum ProfileMenu: CaseIterable, MenuItemType {
    //main
    case editProfile
    case manageGroup
    case managePost
    case manageAccount
    case manageApp
    
    
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
                case .manageApp:
                    return "설정"
            }
        }
    }
    
    var image: Image {
        get {
            switch self {
                case .editProfile:
                    Image("editProfile")
                        .renderingMode(.template)
                        
                case .manageGroup:
                    Image("manageGroup")
                        .renderingMode(.template)
                        
                case .managePost:
                    Image("managePost")
                        .renderingMode(.template)
                        
                case .manageAccount:
                    Image("manageAccount")
                        .renderingMode(.template)
                        
                case .manageApp:
                    Image(systemName: "gear")
                        .renderingMode(.template)
            }
        }
    }
}

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
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
        .background(Color.background)
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
                            ManageGroupView()
                            
                        case .managePost:
                            ManagePostView()
                            
                        case .manageAccount:
                            ManageAccountView()
                            
                        case .manageApp:
                            ManageAppView()
                    }
                } label: {
                    MenuItem(menu: menu)
                }
                .onDisappear {
                    viewModel.send(.updateUserData)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    

}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}

