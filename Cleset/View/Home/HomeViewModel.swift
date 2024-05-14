//
//  HomeViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    enum Action {
        case fetchClothes
        case fetchClothGroups
        case fetchSeasonClothes(Season)
        case fetchCategoryClothes(Category)
        case fetchGroupCloth(ClothGroupObject)
        case searchButtonTap(String)
        case groupTabSelected
    }
    
    @Published var clothes: [ClothCellViewModel] = []
    @Published var groupList: [ClothGroupObject] = []
    @Published var loading: Bool = false
    
    private let container: DIContainer
    
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchClothes:
                loading = true
                container.services.clothService.getClothList()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { [weak self] list in
                        guard let self = self else { return }
                        self.clothes = self.makeClothViewModels(with: list)
                    }
                    .store(in: &subscriptions)
                
                
            case .fetchClothGroups:
                loading = true
                container.services.groupService.getClothGroupList()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { groupList in
                        self.groupList = groupList
                    }.store(in: &subscriptions)
                
            case let .fetchSeasonClothes(season):
                loading = true
                container.services.clothService.getSeasonCloth(season: season)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { [weak self] seasonClothList in
                        guard let self = self else { return }
                        self.clothes = self.makeClothViewModels(with: seasonClothList)
                    }.store(in: &subscriptions)
                
            case let .fetchCategoryClothes(category):
                loading = true
                container.services.clothService.getCategoryCloth(category: category)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { [weak self] categoryClothList in
                        guard let self = self else { return }
                        self.clothes = self.makeClothViewModels(with: categoryClothList)
                    }.store(in: &subscriptions)
                
            case let .fetchGroupCloth(group):
                loading = true
                container.services.clothService.getGroupCloth(group: group)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        self?.loading = false
                    } receiveValue: { [weak self] groupClothList in
                        guard let self = self else { return }
                        self.clothes = self.makeClothViewModels(with: groupClothList)
                    }.store(in: &subscriptions)
                
            case let .searchButtonTap(keyword):
                self.clothes = self.clothes.filter {
                    $0.clothData.name.contains(keyword)
                }
                
            case .groupTabSelected:
                self.clothes = []
                
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
