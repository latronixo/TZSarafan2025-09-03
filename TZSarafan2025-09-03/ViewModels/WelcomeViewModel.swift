//
//  WelcomeViewModel.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var user: User?
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        self.user = authService.currentUser
    }
    
    func signOut() {
        authService.signOut()
    }
}
