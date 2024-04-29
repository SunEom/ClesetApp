//
//  ClothService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

enum ClothServiceError: Error {
    case networkError(Error)
}

protocol ClothServiceType {
    func getClothList() -> AnyPublisher<[ClothObject], ClothServiceError>
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError>
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ClothServiceError>
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ClothServiceError>
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ClothServiceError>
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ClothServiceError>
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ClothServiceError>
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ClothServiceError>
}

final class ClothService: ClothServiceType {
    
    let clothRepository: ClothRepository = ClothNetworkRepository()
    
    func getClothList() -> AnyPublisher<[ClothObject], ClothServiceError> {
        return clothRepository.getClothList()
            .mapError { ClothServiceError.networkError($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError> {
        return clothRepository.toggleFavorite(
            clothId: clothId,
            favorite: favorite
        )
        .mapError { ClothServiceError.networkError($0) }
        .eraseToAnyPublisher()
    }
    
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ClothServiceError> {
        return clothRepository
            .getClothGroupList()
            .mapError { ClothServiceError.networkError($0) }
            .eraseToAnyPublisher()
    }
    
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ClothServiceError> {
        return clothRepository.createNewGroup(groupName: groupName)
            .mapError { ClothServiceError.networkError($0) }
            .eraseToAnyPublisher()
    }
    
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return clothRepository.getSeasonCloth(season: season)
            .mapError { ClothServiceError.networkError($0)}
            .eraseToAnyPublisher()
    }
    
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return clothRepository.getCategoryCloth(category: category)
            .mapError { ClothServiceError.networkError($0)}
            .eraseToAnyPublisher()
    }
    
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return clothRepository.getGroupCloth(group: group)
            .mapError { ClothServiceError.networkError($0)}
            .eraseToAnyPublisher()
    }
    
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ClothServiceError> {
        return clothRepository.addToGroup(cloth: cloth, to: group)
            .mapError { ClothServiceError.networkError($0)}
            .eraseToAnyPublisher()
    }
}

final class StubClothService: ClothServiceType {
    func getClothList() -> AnyPublisher<[ClothObject], ClothServiceError> {
        return Just(ClothObject.stubList)
            .setFailureType(to: ClothServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ClothServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ClothServiceError> {
        return Just(ClothGroupObject.stubList)
            .setFailureType(to: ClothServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ClothServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return Just(ClothObject.stubList)
            .map { $0.filter { $0.season.contains(season.displayName) }}
            .setFailureType(to: ClothServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return Just(ClothObject.stubList)
            .map { $0.filter { $0.category.contains(category.rawValue) }}
            .setFailureType(to: ClothServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ClothServiceError> {
        return Just(group.folderId == 1 ? ClothObject.stubList : [])
            .setFailureType(to: ClothServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ClothServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
