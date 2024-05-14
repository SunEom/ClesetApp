//
//  ClothRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol ClothRepository {
    func createNewCloth(name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, NetworkError>
    func updateCloth(clothId: Int, name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, NetworkError>
    func fetchClothData(clothId: Int) -> AnyPublisher<ClothObject, NetworkError>
    func getClothList() -> AnyPublisher<[ClothObject], NetworkError>
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, NetworkError>
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], NetworkError>
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], NetworkError>
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], NetworkError>
    func deleteCloth(clothId: Int) -> AnyPublisher<Void, NetworkError>
}

final class ClothNetworkRepository: NetworkRepository, ClothRepository {
    func createNewCloth(name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, NetworkError> {
        let body: [String: Any] = [
            "name": name,
            "category": category.rawValue,
            "brand": brand,
            "size": size,
            "place": place,
            "season": Season.getSeasonsString(with: season),
            "cloth_body": memo
        ]
        
        return postData(withPath: "cloth/create", body: body, imageData: imageData, bodyName: "createClothReq")
            .decode(type: ClothObject.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateCloth(clothId: Int, name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, NetworkError> {
        let body: [String: Any] = [
            "cloth_id": clothId,
            "name": name,
            "category": category.rawValue,
            "brand": brand,
            "size": size,
            "place": place,
            "season": Season.getSeasonsString(with: season),
            "cloth_body": memo
        ]
        
        return postData(withPath: "cloth/update", body: body, imageData: imageData, bodyName: "updateClothReq")
            .decode(type: ClothObject.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchClothData(clothId: Int) -> AnyPublisher<ClothObject, NetworkError> {
        return fetchData(withPath: "cloth/\(clothId)")
            .decode(type: ClothObject.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func getClothList() -> AnyPublisher<[ClothObject], NetworkError> {
        return postData(withPath: "cloth")
            .decode(type: [ClothObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, NetworkError> {
        
        let body: [String: Any] = [
            "cloth_id": clothId,
            "favorite": favorite
        ]
        
        return postData(withPath: "cloth/change_favorite", body: body)
            .map { _ in () }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], NetworkError> {
        let body: [String: Any] = [
            "season": season.displayName,
        ]
        
        return postData(withPath: "cloth/season", body: body)
            .decode(type: [ClothObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], NetworkError> {
        let body: [String: Any] = [
            "category": category.rawValue,
        ]
        
        return postData(withPath: "cloth/category", body: body)
            .decode(type: [ClothObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], NetworkError> {
        let body: [String: Any] = [
            "folder_id": group.folderId,
        ]
        
        return postData(withPath: "cloth/folder/detail", body: body)
            .decode(type: [ClothObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteCloth(clothId: Int) -> AnyPublisher<Void, NetworkError> {
        let body: [String: Any] = [
            "cloth_id": clothId
        ]
        
        return postData(withPath: "cloth/delete", body: body)
            .map { _ in Void() }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}
