//
//  LoginViewModel.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    private let container: DIContainer
    private var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var userNeedToSignUp: Bool = false
    private let authViewModel: AuthViewModel
    
    enum Action {
        case FBGoogleLogin
        case checkUserData
    }
    
    init(container: DIContainer, authViewModel: AuthViewModel) {
        self.container = container
        self.authViewModel = authViewModel
    }
    
    func send(_ action: Action) {
        switch action {
            case .FBGoogleLogin:
                container.services
                    .authService.login()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: {[weak self] _ in
                        self?.send(.checkUserData)
                    }.store(in: &subscriptions)

            case .checkUserData:
                container.services
                    .userService.checkUserAlreadySigned()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                    } receiveValue: { [weak self] isAlreadySigned in
                        if isAlreadySigned {
                            self?.authViewModel.send(.fetchUserData)
                        } else {
                            self?.userNeedToSignUp = true
                        }
                    }.store(in: &subscriptions)

        }
    }
}
