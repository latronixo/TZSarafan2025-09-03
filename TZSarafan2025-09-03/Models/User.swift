//
//  User.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let me: User
}

struct JSONRPCRequest: Codable {
    let jsonrpc: String
    let method: String
    let params: [String: String]
    let id: Int
    
    init(method: String, params: [String: String], id: Int = 1) {
        self.jsonrpc = "2.0"
        self.method = method
        self.params = params
        self.id = id
    }
}

struct JSONRPCResponse<T: Codable>: Codable {
    let jsonrpc: String
    let result: T?
    let error: JSONRPCError?
    let id: Int
}

struct JSONRPCError: Codable {
    let code: Int
    let message: String
}

