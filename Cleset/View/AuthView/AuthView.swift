//
//  AuthView.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import SwiftUI
import Combine
struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            if !viewModel.authenticatedChecked {
                Group {
                    Spacer()
                    Image("logo1")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                    Spacer()
                }
            } else {
                switch viewModel.authenticatedState {
                    case .authenticated:
                        MainTabView()
                            .environmentObject(viewModel)
                    case .unauthenticated:
                        LoginView(viewModel: LoginViewModel(container: container, authViewModel: viewModel))
                }
            }
        }
        .background(Color.logoBg)
        .onAppear {
            viewModel.send(.checkAuthenticatedState)
        }
        
    
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel(container: .stub))
}
