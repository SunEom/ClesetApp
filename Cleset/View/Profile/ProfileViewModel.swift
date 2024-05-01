//
//  ProfileViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/29/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    enum Action {
        case updateUserData
    }
        
    @Published var userData: UserModel = UserManager.getUserData() ?? .stub
    
    func send(_ action: Action) {
        switch action {
            case .updateUserData:
                userData = UserManager.getUserData() ?? .stub
        }
    }
}
