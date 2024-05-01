//
//  UserRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol UserRepository {
    func getUserData() -> AnyPublisher<UserModel, NetworkError>
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, NetworkError>
    func updateUser(userData: UserModel) -> AnyPublisher<UserModel, NetworkError>
    func deleteAccount() -> AnyPublisher<Void, NetworkError>
}

final class UserNetworkRepository: NetworkRepository, UserRepository {
    func getUserData() -> AnyPublisher<UserModel, NetworkError> {
        return postData(withPath: "user/userinfo")
            .decode(type: UserObject.self, decoder: JSONDecoder())
            .map { $0.toModel() }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func nicknameCheck(nickname: String) -> AnyPublisher<Bool, NetworkError> {
        let body: [String: Any] = [
            "nickname": nickname,
        ]
        
        return postData(withPath: "user/check_nickname", body: body)
            .decode(type: Bool.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0)}
            .eraseToAnyPublisher()
    }
    
    func updateUser(userData: UserModel) -> AnyPublisher<UserModel, NetworkError> {
        let body: [String: Any] = [
            "nickname": userData.nickname,
            "age": userData.age,
            "gender": userData.gender.rawValue
        ]
        
        return postData(withPath: "user/update", body: body)
            .decode(type: UserObject.self, decoder: JSONDecoder())
            .map { $0.toModel() }
            .mapError { NetworkError.customError($0)}
            .eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Void, NetworkError> {
        return postData(withPath: "user/signout")
            .map { _ in ()}
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}
