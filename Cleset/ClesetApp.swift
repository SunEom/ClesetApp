//
//  ClesetApp.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct ClesetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var container: DIContainer = .init(services: Services())
    @AppStorage(K.AppStorage.Appearance) var appearanceValue: Int = UserDefaults.standard.integer(forKey: K.AppStorage.Appearance)
    
    var body: some Scene {
        WindowGroup {
            AuthView(viewModel: AuthViewModel(container: container))
                .environmentObject(container)
                .onAppear {
                    container.appearanceController.changeAppearance(AppearanceStyle(rawValue: appearanceValue))
                }
        }
    }
}
