//
//  ClothCellViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation
import Combine

final class ClothCellViewModel: ObservableObject {
    @Published var clothData: ClothObject
    
    enum Action {
        case toggleFavorite
    }
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(clothData: ClothObject, container: DIContainer) {
        self.clothData = clothData
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .toggleFavorite:
                guard let idToken = UserManager.getIdToken() else { return }
                container.services.clothService.toggleFavorite(
                    idToken: idToken,
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
