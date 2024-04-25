//
//  Services.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation

protocol ServiceType {
    var authService: AuthServiceType { get set }
}

final class Services: ServiceType {
    var authService: AuthServiceType
    
    init(
        authService: AuthServiceType = AuthService()
    ) {
        self.authService = authService
    }
}

final class StubService: ServiceType {
    var authService: AuthServiceType = StubAuthService()
}
