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
    }
    
    @Published var clothes: [ClothCellViewModel] = []
    var container: DIContainer
    
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .fetchClothes:
                container.services.clothService.getClothList()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] list in
                        guard let self = self else { return }
                        self.clothes = list.map { ClothCellViewModel(clothData: $0, container: self.container)}
                    }
                    .store(in: &subscriptions)
        }
    }
    
}
