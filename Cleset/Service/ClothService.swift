//
//  ClothService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

enum ClothServiceError: Error {
    case customError(Error)
}

protocol ClothServiceType {
    func getClothList(idToken: String) -> AnyPublisher<[ClothObject], ClothServiceError>
    func toggleFavorite(idToken: String, clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError>
}

final class ClothService: ClothServiceType {
    
    let clothRepository: ClothRepository = ClothNetworkRepository()
    
    func getClothList(idToken: String) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return clothRepository.getClothList(idToken: idToken)
            .mapError { ClothServiceError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(idToken: String, clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError> {
        return clothRepository.toggleFavorite(
            idToken: idToken,
            clothId: clothId,
            favorite: favorite
        )
        .mapError { ClothServiceError.customError($0) }
        .eraseToAnyPublisher()
    }
}

final class StubClothService: ClothServiceType {
    func getClothList(idToken: String) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func toggleFavorite(idToken: String, clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
