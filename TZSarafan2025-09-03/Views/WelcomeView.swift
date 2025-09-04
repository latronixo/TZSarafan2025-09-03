//
//  WelcomeView.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var authService: AuthService
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Welcome message
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Добро пожаловать!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if let user = authService.currentUser {
                        Text("Привет, \(user.name)!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // User info card
                if let user = authService.currentUser {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Информация о пользователе")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text("ID:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(user.id)")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Имя:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Sign out button
                Button(action: {
                    authService.signOut()
                }) {
                    Text("Выйти")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colorScheme == .dark ? Color(red: 0.9, green: 0.25, blue: 0.2) : Color.red)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("Главная")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthService())
}

