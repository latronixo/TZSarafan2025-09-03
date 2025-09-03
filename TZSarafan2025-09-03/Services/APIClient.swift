//
//  APIClient.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation

class APIClient {
    private let baseURL = "https://api.court360.ai/rpc/client"
    private let session = URLSession.shared
    
    func firebaseLogin(idToken: String) async throws -> AuthResponse {
        let request = JSONRPCRequest(
            method: "auth.firebaseLogin",
            params: ["fbIdToken": idToken]
        )
        
        return try await performRequest(request)
    }
    
    private func performRequest<T: Codable>(_ request: JSONRPCRequest) async throws -> T {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw APIError.encodingError
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.httpError(httpResponse.statusCode)
            }
            
            let jsonResponse = try JSONDecoder().decode(JSONRPCResponse<T>.self, from: data)
            
            if let error = jsonResponse.error {
                throw APIError.serverError(error.message)
            }
            
            guard let result = jsonResponse.result else {
                throw APIError.noData
            }
            
            return result
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case invalidResponse
    case httpError(Int)
    case serverError(String)
    case noData
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .encodingError:
            return "Ошибка кодирования данных"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .httpError(let code):
            return "HTTP ошибка: \(code)"
        case .serverError(let message):
            return "Ошибка сервера: \(message)"
        case .noData:
            return "Нет данных в ответе"
        case .networkError(let message):
            return "Ошибка сети: \(message)"
        }
    }
}
