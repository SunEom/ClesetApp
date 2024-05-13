//
//  ManageClothByGroupViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/12/24.
//

import Foundation
import Combine

final class ManageClothByGroupViewModel: ObservableObject {
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var groups: [ClothGroupObject] = []
    @Published var clothes: [ClothCellViewModel] = []
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case fetchGroups
        case fetchGroupCloth(ClothGroupObject)
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchGroups:
                container.services.groupService
                    .getClothGroupList()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] groups in
                        self?.groups = groups
                    }.store(in: &subscriptions)
                
            case let .fetchGroupCloth(group):
                container.services.clothService.getGroupCloth(group: group)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] groupClothList in
                        guard let self = self else { return }
                        self.clothes = self.makeClothViewModels(with: groupClothList)
                    }.store(in: &subscriptions)
        }
    }
    
    private func makeClothViewModels(with clothList: [ClothObject]) -> [ClothCellViewModel] {
        return clothList.map { ClothCellViewModel(clothData: $0, container: self.container)}
    }
    
    func getFilteredList(for searchWord: String) -> [ClothCellViewModel] {
        if searchWord == "" {
            return self.clothes
        } else {
            return self.clothes.filter { viewModel in
                viewModel.clothData.filter(searchWord: searchWord)
            }
        }
    }
}
