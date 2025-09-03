//
//  LoginViewModel.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signInWithApple() {
        authService.signInWithApple()
    }
    
    func signInWithGoogle() {
        authService.signInWithGoogle()
    }
    
    func clearError() {
        errorMessage = nil
    }
}
