//
//  ContentView.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                WelcomeView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authService.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
}
