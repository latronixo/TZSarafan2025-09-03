//
//  LoginView.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @StateObject private var authService: AuthService
    
    init() {
        let authService = AuthService()
        self._authService = StateObject(wrappedValue: authService)
        self._viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Welcome text
                VStack(spacing: 16) {
                    Text("WELCOME")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Enter your phone number. We will send you an SMS with a confirmation code to this number.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Peony flower illustration placeholder
                Image(systemName: "leaf.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.pink)
                    .padding(.bottom, 20)
                
                Spacer()
                
                // Sign in buttons
                VStack(spacing: 16) {
                    // Apple Sign In Button
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            viewModel.signInWithApple()
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(8)
                    
                    // Google Sign In Button
                    Button(action: {
                        viewModel.signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.primary)
                            Text("Continue with Google")
                                .foregroundColor(.primary)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Legal disclaimer
                VStack(spacing: 4) {
                    Text("By continuing, you agree to Assetsy's")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Button("Terms of Use") {
                            // Handle terms of use
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Text("and")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Privacy Policy") {
                            // Handle privacy policy
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            
            // Loading overlay
            if authService.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("Вход...")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
            }
        }
        .alert("Ошибка", isPresented: .constant(authService.errorMessage != nil)) {
            Button("OK") {
                authService.errorMessage = nil
            }
        } message: {
            Text(authService.errorMessage ?? "")
        }
    }
}

#Preview {
    LoginView()
}

