//
//  DetailViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    enum Action {
        case toggleFavorite
    }
    
    @Published var clothData: ClothObject
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(clothData: ClothObject, container: DIContainer) {
        self.clothData = clothData
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .toggleFavorite:
                container.services.clothService.toggleFavorite(
                    clothId: clothData.clothId,
                    favorite: clothData.favorite
                )
                .receive(on: DispatchQueue.main)
                .sink { completion in
                } receiveValue: { [weak self] _ in
                    self?.clothData.favToggle()
                }.store(in: &subscriptions)
        }
    }
}
