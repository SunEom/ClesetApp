//
//  ClothRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol ClothRepository {
    func getClothList() -> AnyPublisher<[ClothObject], NetworkError>
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, NetworkError>
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], NetworkError>
    func createNewGroup(groupName: String) -> AnyPublisher<Void, NetworkError>
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], NetworkError>
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], NetworkError>
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], NetworkError>
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, NetworkError>
}

final class ClothNetworkRepository: NetworkRepository, ClothRepository {
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
    
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], NetworkError> {
        return postData(withPath: "cloth/folder")
            .decode(type: [ClothGroupObject].self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func createNewGroup(groupName: String) -> AnyPublisher<Void, NetworkError> {
        let body: [String: Any] = [
            "folder_name": groupName,
        ]
        
        return postData(withPath: "cloth/folder/create", body: body)
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
    
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, NetworkError> {
        let body: [String: Any] = [
            "folder_id": group.folderId,
            "cloth_id": cloth.clothId
        ]
        
        return postData(withPath: "cloth/folder/insert", body: body)
            .map { _ in () }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}
