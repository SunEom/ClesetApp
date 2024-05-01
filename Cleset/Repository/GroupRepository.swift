//
//  GroupRepository.swift
//  Cleset
//
//  Created by 엄태양 on 4/30/24.
//

import Foundation
import Combine

protocol GroupRepository {
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], NetworkError>
    func createNewGroup(groupName: String) -> AnyPublisher<Void, NetworkError>
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, NetworkError>
    func removeGroup(group: ClothGroupObject) -> AnyPublisher<Void, NetworkError>
    func updateGroupName(group: ClothGroupObject, newName: String) -> AnyPublisher<ClothGroupObject, NetworkError>
}

final class GroupNetworkRepository: NetworkRepository, GroupRepository {
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
    
    func removeGroup(group: ClothGroupObject) -> AnyPublisher<Void, NetworkError> {
        let body: [String: Any] = [
            "folder_id": group.folderId,
        ]
        
        return postData(withPath: "cloth/folder/delete", body: body)
            .map { _ in () }
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
    
    func updateGroupName(group: ClothGroupObject, newName: String) -> AnyPublisher<ClothGroupObject, NetworkError> {
        let body: [String: Any] = [
            "folder_id": group.folderId,
            "folder_name": newName
        ]
        
        return postData(withPath: "cloth/folder/update", body: body)
            .decode(type: ClothGroupObject.self, decoder: JSONDecoder())
            .mapError { NetworkError.customError($0) }
            .eraseToAnyPublisher()
    }
}
