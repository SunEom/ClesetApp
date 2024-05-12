//
//  GroupService.swift
//  Cleset
//
//  Created by 엄태양 on 4/30/24.
//

import Foundation
import Combine

protocol GroupServiceType {
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ServiceError>
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ServiceError>
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ServiceError>
    func removeGroup(group: ClothGroupObject) -> AnyPublisher<Void, ServiceError>
    func updateGroupName(group: ClothGroupObject, newName: String) -> AnyPublisher<ClothGroupObject, ServiceError>
}

final class GroupService: GroupServiceType {
    
    let groupRepository: GroupRepository = GroupNetworkRepository()
    
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ServiceError> {
        return groupRepository
            .getClothGroupList()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ServiceError> {
        return groupRepository
            .createNewGroup(groupName: groupName)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ServiceError> {
        return groupRepository
            .addToGroup(cloth: cloth, to: group)
            .mapError { ServiceError.error($0)}
            .eraseToAnyPublisher()
    }
    
    func removeGroup(group: ClothGroupObject) -> AnyPublisher<Void, ServiceError> {
        return groupRepository
            .removeGroup(group: group)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func updateGroupName(group: ClothGroupObject, newName: String) -> AnyPublisher<ClothGroupObject, ServiceError> {
        return groupRepository
            .updateGroupName(group: group, newName: newName)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubGroupService: GroupServiceType {
    func getClothGroupList() -> AnyPublisher<[ClothGroupObject], ServiceError> {
        return Just(ClothGroupObject.stubList)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func createNewGroup(groupName: String) -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func addToGroup(cloth: ClothObject, to group: ClothGroupObject) -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func removeGroup(group: ClothGroupObject) -> AnyPublisher<Void, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func updateGroupName(group: ClothGroupObject, newName: String) -> AnyPublisher<ClothGroupObject, ServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}
