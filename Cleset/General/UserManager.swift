//
//  UserManager.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation

class UserManager {
    
    private init() {}
    
    private static var idToken: String?
    private static var userData: UserObject?
    
    static func setIdToken(_ token: String) {
        UserManager.idToken = token
    }
    
    static func getIdToken() -> String? {
        return UserManager.idToken
    }
    
    static func setUserData(with data: UserObject) {
        self.userData = data
    }
    
    static func getUserData() -> UserObject? {
        return self.userData
    }
    
}
