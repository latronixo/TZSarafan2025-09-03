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
import CryptoKit


@MainActor
class AuthService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient()
    private let tokenStorage = TokenStorage()
    
    private var currentNonce: String?
    
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
        
        let nonce = randomNonceString()
        currentNonce = nonce
         
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
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
        
        guard let nonce = currentNonce else {
            errorMessage = "Invalid state: A login callback was received, but no login request was sent."
            isLoading = false
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: nil
        )
        
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

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate random bytes. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}

@available(iOS 13.0, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()

    return hashString
}

