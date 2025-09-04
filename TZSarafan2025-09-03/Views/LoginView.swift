//
//  LoginView.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var authService: AuthService
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .overlay(
                Image("wheel")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 600, height: 600)
                    .offset(x: 50, y: 50)
            )
            
            VStack() {
                HStack {
                     Spacer()
                     Button("Skip") {
                     }
                     .font(.body)
                     .foregroundColor(.secondary)
                 }
                .padding(.horizontal, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    HStack{
                        Text("WELCOME")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    Text("Enter your phone number. We will send you an SMS with a confirmation code to this number.")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                Image("flower")
                    .font(.system(size: 120))
                    .foregroundColor(.pink)
                    .frame(width: 200, height: 400)
                    .padding(.top, 50)
                
                VStack(spacing: 16) {
                    Button(action: {
                        authService.signInWithApple()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .frame(width: 22, height: 22)
                            Text("Continue with Apple")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colorScheme == .dark ? Color.gray : Color.white)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        authService.signInWithGoogle()
                    }) {
                        HStack {
                            Image("googleIcon")
                                .foregroundColor(.primary)
                                .frame(width: 22, height: 22)
                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colorScheme == .dark ? .gray : .white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 4) {
                    Text("By continuing, you agree to Assetsy's")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Button("Terms of Use") {
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Text("and")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Privacy Policy") {
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            
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
        .environmentObject(AuthService())
}

