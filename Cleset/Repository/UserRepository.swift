//
//  UserRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol UserRepository {
    func getUserData() -> AnyPublisher<UserObject, NetworkError>
}

final class UserNetworkRepository: NetworkRepository, UserRepository {
    func getUserData() -> AnyPublisher<UserObject, NetworkError> {
        return postData(withPath: "user/userinfo")
            .decode(type: UserObject.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}