//
//  LoginView.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                
                Spacer()
                
                Image("logo1")
                    .resizable()
                    .frame(width: 400, height: 400)
                    
                GoogleSignInButton(
                    scheme: .light,
                    style: .wide,
                    action: {
                        viewModel.send(.FBGoogleLogin)
                    })
                
                .frame(width: 200, height: 60, alignment: .center)
                
                Spacer()
            }
            .padding(.vertical, 30)
                        
            Spacer()
        }
        .background(Color.logoBg)
        .fullScreenCover(isPresented: $viewModel.userNeedToSignUp) {
            VStack {
                SignUpView(viewModel: SignUpViewModel(container: container))
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(container: .stub, authViewModel: AuthViewModel(container: .stub)))
}
