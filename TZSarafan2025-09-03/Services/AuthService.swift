//
//  AuthService.swift
//  TZSarafan2025-09-03
//
//  Created by Валентин on 03.09.2025.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn

@MainActor
class AuthService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient()
    private let tokenStorage = TokenStorage()
    
    override init() {
        super.init()
        checkAuthState()
    }
    
    // MARK: - Auth State Management
    
    private func checkAuthState() {
        if let accessToken = tokenStorage.getAccessToken() {
            // TODO: Validate token with backend
            isAuthenticated = true
        }
    }
    
    // MARK: - Apple Sign In
    
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Google Sign In
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            errorMessage = "Не удалось получить root view controller"
            isLoading = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            Task { @MainActor in
                if let error = error {
                    self?.errorMessage = "Ошибка входа через Google: \(error.localizedDescription)"
                    self?.isLoading = false
                    return
                }
                
                guard let result = result else {
                    self?.errorMessage = "Не удалось получить результат входа"
                    self?.isLoading = false
                    return
                }
                
                await self?.handleGoogleSignInResult(result)
            }
        }
    }
    
    private func handleGoogleSignInResult(_ result: GIDSignInResult) async {
        guard let idToken = result.user.idToken?.tokenString else {
            errorMessage = "Не удалось получить ID токен"
            isLoading = false
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            await authenticateWithBackend(idToken: idToken)
        } catch {
            errorMessage = "Ошибка Firebase Auth: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Backend Authentication
    
    private func authenticateWithBackend(idToken: String) async {
        do {
            let response = try await apiClient.firebaseLogin(idToken: idToken)
            tokenStorage.saveAccessToken(response.accessToken)
            currentUser = response.me
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = "Ошибка авторизации: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            tokenStorage.clearTokens()
            isAuthenticated = false
            currentUser = nil
        } catch {
            errorMessage = "Ошибка выхода: \(error.localizedDescription)"
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let idTokenString = String(data: identityToken, encoding: .utf8) else {
            errorMessage = "Не удалось получить Apple ID токен"
            isLoading = false
            return
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nil)
        
        Task {
            do {
                let authResult = try await Auth.auth().signIn(with: credential)
                await authenticateWithBackend(idToken: idTokenString)
            } catch {
                await MainActor.run {
                    errorMessage = "Ошибка Firebase Auth: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        errorMessage = "Ошибка Apple Sign In: \(error.localizedDescription)"
        isLoading = false
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
