//
//  UserService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol UserServiceType {
    func signUpUser(nickname: String, gender: Gender, age: Int) -> AnyPublisher<UserModel, ServiceError>
    func getUserData() -> AnyPublisher<UserModel, ServiceError>
    func checkUserAlreadySigned() -> AnyPublisher<Bool, ServiceError>
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, ServiceError>
    func updateUser(user: UserModel) -> AnyPublisher<UserModel, ServiceError>
    func deleteAccount() -> AnyPublisher<Void, ServiceError>
}

final class UserService: UserServiceType {
    
    let userRepository: UserRepository = UserNetworkRepository()
    
    func signUpUser(nickname: String, gender: Gender, age: Int) -> AnyPublisher<UserModel, ServiceError> {
        return userRepository.signUpUser(nickname: nickname, gender: gender, age: age)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func getUserData() -> AnyPublisher<UserModel, ServiceError> {
        return userRepository.getUserData()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func checkUserAlreadySigned() -> AnyPublisher<Bool, ServiceError> {
        return userRepository.checkUserAlreadySigned()
            .mapError { ServiceError.error($0)}
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
    func signUpUser(nickname: String, gender: Gender, age: Int) -> AnyPublisher<UserModel, ServiceError> {
        return Just(UserModel.stub)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getUserData() -> AnyPublisher<UserModel, ServiceError> {
        return Just(UserModel(id: 1, nickname: "Suneom", gender: .male, age: 27, uid: "asdfqwer1234"))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func checkUserAlreadySigned() -> AnyPublisher<Bool, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, ServiceError> {
        return Just(false)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func updateUser(user: UserModel) -> AnyPublisher<UserModel, ServiceError> {
        return Just(user)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
