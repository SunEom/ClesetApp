//
//  AuthService.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation
import Firebase
import GoogleSignIn
import Combine

enum AuthServiceError: Error {
    case clientIDError
    case userDataError
    case tokenError
    case userNotFoundError
    case customError(Error)
    case signOutError(Error)
}

protocol AuthServiceType {
    func checkLoginState() -> AnyPublisher<Bool, AuthServiceError>
    func login() -> AnyPublisher<Void, AuthServiceError>
    func logout() -> AnyPublisher<Void, AuthServiceError>
}

final class AuthService: AuthServiceType {
    
    func checkLoginState() -> AnyPublisher<Bool, AuthServiceError> {
        Future { promise in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error {
                    promise(.failure(AuthServiceError.customError(error)))
                }
                if let user = Auth.auth().currentUser {
                    user.getIDToken() { token, error in
                        if let error {
                            promise(.failure(AuthServiceError.customError(error)))
                        }
                        
                        if let token = token {
                            UserManager.setIdToken(token)
                            promise(.success(true))
                        } else {
                            promise(.failure(AuthServiceError.tokenError))
                        }
                    }
                } else {
                    promise(.success(false))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func login() -> AnyPublisher<Void, AuthServiceError> {
        return googleLogin()
            .eraseToAnyPublisher()
    }
    
    
    
    private func googleLogin() -> AnyPublisher<Void, AuthServiceError> {
        return Future { promise in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                promise(.failure(AuthServiceError.clientIDError))
                return
            }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let presentingView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingView) { signInResult, error in
                
                guard let user = signInResult?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    promise(.failure(AuthServiceError.userDataError))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
                
                Auth.auth().signIn(with: credential) { result, error in
                    if let error {
                        promise(.failure(AuthServiceError.customError(error)))
                        return
                    }
                    
                    if let curUser = Auth.auth().currentUser {
                        curUser.getIDToken(completion: { token, error in
                            if let error {
                                promise(.failure(AuthServiceError.customError(error)))
                            }
                            if let token = token {
                                UserManager.setIdToken(token)
                                promise(.success(()))
                            } else {
                                promise(.failure(AuthServiceError.tokenError))
                            }
                        })
                    } else {
                        promise(.failure(AuthServiceError.userNotFoundError))
                    }
                    
                    
                }
                
            }
        }.eraseToAnyPublisher()
        
    }
    
    func logout() -> AnyPublisher<Void, AuthServiceError> {
        Future { promise in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                promise(.success(()))
            } catch let signOutError as NSError {
                promise(.failure(AuthServiceError.signOutError(signOutError)))
            }
        }
        .eraseToAnyPublisher()
    }
    
}

final class StubAuthService: AuthServiceType {
    func checkLoginState() -> AnyPublisher<Bool, AuthServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func login() -> AnyPublisher<Void, AuthServiceError> {
        return Empty().eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, AuthServiceError> {
        return Empty().eraseToAnyPublisher()
    }
}



