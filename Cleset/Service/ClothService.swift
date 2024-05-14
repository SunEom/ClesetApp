//
//  ClothService.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

protocol ClothServiceType {
    func createNewCloth(name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError>
    func updateCloth(clothId: Int, name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError>
    func fetchClothData(clothId: Int) -> AnyPublisher<ClothObject, ServiceError>
    func getClothList() -> AnyPublisher<[ClothObject], ServiceError>
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ServiceError>
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ServiceError>
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ServiceError>
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ServiceError>
    func deleteCloth(clothId: Int) -> AnyPublisher<Void, ServiceError>
}

final class ClothService: ClothServiceType {
    
    let clothRepository: ClothRepository = ClothNetworkRepository()
    
    func createNewCloth(name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError> {
        return clothRepository.createNewCloth(
            name: name,
            category: category,
            brand: brand,
            size: size,
            place: place,
            season: season,
            memo: memo,
            imageData: imageData
        )
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
    
    func updateCloth(clothId: Int, name: String, category: Category, brand: String, size: String, place: String, season:[Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError> {
        return clothRepository.updateCloth(
            clothId: clothId,
            name: name,
            category: category,
            brand: brand,
            size: size,
            place: place,
            season: season,
            memo: memo,
            imageData: imageData
        )
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
    
    func fetchClothData(clothId: Int) -> AnyPublisher<ClothObject, ServiceError> {
        return clothRepository
            .fetchClothData(clothId: clothId)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getClothList() -> AnyPublisher<[ClothObject], ServiceError> {
        return clothRepository.getClothList()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ServiceError> {
        return clothRepository.toggleFavorite(
            clothId: clothId,
            favorite: favorite
        )
        .mapError { ServiceError.error($0) }
        .eraseToAnyPublisher()
    }
    
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ServiceError> {
        return clothRepository.getSeasonCloth(season: season)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ServiceError> {
        return clothRepository.getCategoryCloth(category: category)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ServiceError> {
        return clothRepository.getGroupCloth(group: group)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func deleteCloth(clothId: Int) -> AnyPublisher<Void, ServiceError> {
        return clothRepository.deleteCloth(clothId: clothId)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
}

final class StubClothService: ClothServiceType {
    
    func createNewCloth(name: String, category: Category, brand: String, size: String, place: String, season: [Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError> {
        return Just(ClothObject.stubList[0])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func updateCloth(clothId: Int, name: String, category: Category, brand: String, size: String, place: String, season: [Season], memo: String, imageData: Data?) -> AnyPublisher<ClothObject, ServiceError> {
        return Just(ClothObject.stubList[0])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchClothData(clothId: Int) -> AnyPublisher<ClothObject, ServiceError> {
        return Just(ClothObject.stubList.filter { $0.clothId == clothId }[0] )
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getClothList() -> AnyPublisher<[ClothObject], ServiceError> {
        return Just(ClothObject.stubList)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(clothId: Int, favorite: Int) -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func getSeasonCloth(season: Season) -> AnyPublisher<[ClothObject], ServiceError> {
        return Just(ClothObject.stubList)
            .map { $0.filter { $0.season.contains(season.displayName) }}
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getCategoryCloth(category: Category) -> AnyPublisher<[ClothObject], ServiceError> {
        return Just(ClothObject.stubList)
            .map { $0.filter { $0.category.contains(category.rawValue) }}
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getGroupCloth(group: ClothGroupObject) -> AnyPublisher<[ClothObject], ServiceError> {
        return Just(group.folderId == 1 ? ClothObject.stubList : [])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    
    func deleteCloth(clothId: Int) -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
}
