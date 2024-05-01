//
//  AuthViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation
import Combine

enum AuthenticatedState {
    case authenticated
    case unauthenticated
}

final class AuthViewModel: ObservableObject {
    enum Action {
        case checkAuthenticatedState
        case login
        case fetchUserData
        case logout
    }
    
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var authenticatedState: AuthenticatedState = .unauthenticated
    @Published var authenticatedChecked: Bool = false
    @Published var loading: Bool = false
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
            case .checkAuthenticatedState:
                container.services.authService.checkLoginState()
                    .sink { completion in
                    } receiveValue: { [weak self] isLogined in
                        if isLogined {
                            self?.send(.fetchUserData)
                        } else {
                            self?.authenticatedState = .unauthenticated
                            self?.authenticatedChecked = true
                            self?.loading = false
                        }
                    }
                    .store(in: &subscriptions)

            case .login:
                container.services.authService.login()
                    .sink { completion in
                    } receiveValue: { [weak self] _ in
                        self?.send(.fetchUserData)
                    }.store(in: &subscriptions)

            case .fetchUserData:
                container.services.userService.getUserData()
                    .receive(on: DispatchQueue.main)
                    .sink {[weak self] completion in
                        switch completion {
                            case .failure:
                                self?.send(.logout)
                            default:
                                break
                        }
                    } receiveValue: { [weak self] user in
                        UserManager.setUserData(with: user)
                        self?.authenticatedState = .authenticated
                        self?.authenticatedChecked = true
                    }.store(in: &subscriptions)
                
            case .logout:
                container.services.authService.logout()
                    .sink { completion in
                    } receiveValue: { [weak self] _ in
                        self?.authenticatedState = .unauthenticated
                        self?.authenticatedChecked = true
                    }.store(in: &subscriptions)

        }
    }
}
