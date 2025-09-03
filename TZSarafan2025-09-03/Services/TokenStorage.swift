//
//  TokenStorage.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation
import Security

class TokenStorage {
    private let accessTokenKey = "access_token"
    
    func saveAccessToken(_ token: String) {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenKey,
            kSecValueData as String: data
        ]
        
        // Удаляем существующий токен
        SecItemDelete(query as CFDictionary)
        
        // Сохраняем новый токен
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Ошибка сохранения токена: \(status)")
        }
    }
    
    func getAccessToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        }
        
        return nil
    }
    
    func clearTokens() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

