//
//  UserService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol UserServiceType {
    func getUserData() -> AnyPublisher<UserModel, ServiceError>
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, ServiceError>
    func updateUser(user: UserModel) -> AnyPublisher<UserModel, ServiceError>
    func deleteAccount() -> AnyPublisher<Void, ServiceError>
}

final class UserService: UserServiceType {
    
    let userRepository: UserRepository = UserNetworkRepository()
    
    func getUserData() -> AnyPublisher<UserModel, ServiceError> {
        return userRepository.getUserData()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, ServiceError> {
        return userRepository.nicknameCheck(nickname: nickname)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateUser(user: UserModel) -> AnyPublisher<UserModel, ServiceError> {
        return userRepository.updateUser(userData: user)
            .mapError{ ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Void, ServiceError> {
        return userRepository
            .deleteAccount()
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
}

final class StubUserService: UserServiceType {
    func getUserData() -> AnyPublisher<UserModel, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateUser(user: UserModel) -> AnyPublisher<UserModel, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
