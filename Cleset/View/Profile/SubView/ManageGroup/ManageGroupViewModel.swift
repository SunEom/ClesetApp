//
//  ManageGroupViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/30/24.
//

import Foundation
import Combine

final class ManageGroupViewModel: ObservableObject {
    enum Action {
        case fetchGroupList
        case deleteGroup(ClothGroupObject)
        case updateGroup(group: ClothGroupObject, newName: String)
    }
    
    @Published var groupList: [ClothGroupObject] = []
    @Published var loading: Bool = false
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchGroupList:
                loading = true
                container.services.groupService.getClothGroupList()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { [weak self] groupList in
                        self?.groupList = groupList
                    }.store(in: &subscriptions)
                
            case let .deleteGroup(group):
                loading = true
                container.services.groupService.removeGroup(group: group)
                    .receive(on: DispatchQueue.main)
                    .sink {[weak self] completion in
                        switch completion {
                            case .failure:
                                self?.loading = false
                            default:
                                return
                        }
                    } receiveValue: { [weak self] _ in
                        self?.send(.fetchGroupList)
                    }.store(in: &subscriptions)
                
            case let .updateGroup(group, newName):
                container.services.groupService.updateGroupName(group: group, newName: newName)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] _ in
                        self?.send(.fetchGroupList)
                    }.store(in: &subscriptions)
        }
    }
}
