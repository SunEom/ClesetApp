//
//  ClothRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol ClothRepository {
    func getClothList(idToken: String) -> AnyPublisher<[ClothObject], NetworkError>
    func toggleFavorite(idToken: String, clothId: Int, favorite: Int) -> AnyPublisher<Void, NetworkError>
}

final class ClothNetworkRepository: NetworkRepository, ClothRepository {
    func getClothList(idToken: String) -> AnyPublisher<[ClothObject], NetworkError> {
        return postData(withPath: "cloth", body: ["idToken": idToken])
            .decode(type: [ClothObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(idToken: String, clothId: Int, favorite: Int) -> AnyPublisher<Void, NetworkError> {
        
        let body: [String: Any] = [
            "idToken": idToken,
            "cloth_id": clothId,
            "favorite": favorite
        ]
        
        return postData(withPath: "cloth/change_favorite", body: body)
            .map { _ in () }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}
