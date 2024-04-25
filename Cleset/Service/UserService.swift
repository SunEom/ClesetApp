//
//  UserService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol UserServiceType {
    func getUserData(idToken: String) -> AnyPublisher<UserObject, AuthServiceError>
}

final class UserService: UserServiceType {
    
    let userRepository: UserRepository = UserNetworkRepository()
    
    func getUserData(idToken: String) -> AnyPublisher<UserObject, AuthServiceError> {
        return userRepository.getUserData(idToken: idToken)
            .mapError { AuthServiceError.customError($0) }
            .eraseToAnyPublisher()
    }
}

final class StubUserService: UserServiceType {
    func getUserData(idToken: String) -> AnyPublisher<UserObject, AuthServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
