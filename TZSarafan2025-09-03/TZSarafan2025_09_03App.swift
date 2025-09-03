//
//  TZSarafan2025_09_03App.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct TZSarafan2025_09_03App: App {
    @StateObject private var authService = AuthService()
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure Google Sign In
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientId = plist["CLIENT_ID"] as? String else {
            fatalError("GoogleService-Info.plist не найден или CLIENT_ID отсутствует")
        }
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.configuration = config
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}
