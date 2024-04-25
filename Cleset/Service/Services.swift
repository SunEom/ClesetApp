//
//  Services.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthServiceType { get set }
    var userService: UserServiceType { get set}
    var clothService: ClothServiceType { get set}
}

final class Services: ServiceType {
    var authService: AuthServiceType
    var userService: UserServiceType
    var clothService: ClothServiceType
    
    init(
        authService: AuthServiceType = AuthService(),
        userService: UserServiceType = UserService(),
        clothService: ClothServiceType = ClothService()
    ) {
        self.authService = authService
        self.userService = userService
        self.clothService = clothService
    }
}

final class StubService: ServiceType {
    var authService: AuthServiceType = StubAuthService()
    var userService: UserServiceType = StubUserService()
    var clothService: ClothServiceType = StubClothService()
}
