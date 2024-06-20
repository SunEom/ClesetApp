//
//  DeleteAccountViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

final class DeleteAccountViewModel: ObservableObject {
    enum Action {
        case deleteButtonTap
    }
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var presentingAlert: Bool = false
    
    init(container: DIContainer){
        self.container = container
    }

    
    func send(_ action: Action) {
        switch action {
            case .deleteButtonTap:
                container.services.userService.deleteAccount()
                    .sink { completion in
                    } receiveValue: { [weak self] _ in
                        self?.presentingAlert = true
                    }
                    .store(in: &subscriptions)
        }
    }
}
