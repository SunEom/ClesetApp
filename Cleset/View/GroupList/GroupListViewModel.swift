//
//  GroupListViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

final class GroupListViewModel: ObservableObject {
    enum Action {
        case fetchGroupList
        case creatNewGroup(groupName: String)
    }
    
    @Published var groups: [ClothGroupObject] = []
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
                container.services.clothService.getClothGroupList()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { list in
                        self.groups = list
                    }.store(in: &subscriptions)
                
            case let .creatNewGroup(groupName):
                loading = true
                container.services.clothService.createNewGroup(groupName: groupName)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self]  _ in
                        self?.send(.fetchGroupList)
                    }.store(in: &subscriptions)

        }
    }
}
