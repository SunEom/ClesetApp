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
    @StateObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                
                Image("logo3")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    
                Spacer()
                
                GoogleSignInButton(
                    scheme: .light,
                    style: .wide,
                    action: {
                        authViewModel.send(.login)
                    })
                .frame(width: 200, height: 60, alignment: .center)
                
                Spacer()
            }
            .padding(.vertical, 30)
                        
            Spacer()
        }
        .background(Color.logoBg)
        
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel(container: DIContainer.stub))
}
