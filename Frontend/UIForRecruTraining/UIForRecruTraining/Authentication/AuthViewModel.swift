
//
//  AuthViewModel.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/3/24.
//

import Foundation

extension AuthView {
    class AuthViewModel: ObservableObject {
        @Published var emailText: String = ""
        @Published var passwordText: String = ""
        @Published var errorMessage: String = ""
        
        @Published var isLoading = false
        @Published var isPasswordVisible = false
        @Published var userExists: Bool? = nil
        
        @Published var signInIntent: Bool = false
        
        @Published var rememberMe: Bool = false {
            didSet {
                UserDefaults.standard.set(rememberMe, forKey: "rememberMe")
            }
        }
        
        let authService = AuthService()

        func checkExistenceOrProceed() {
            isLoading = true
            Task {
                do {
                    let exists = try await authService.checkUserExists(email: emailText)
                    await MainActor.run {
                        userExists = exists
                        isPasswordVisible = true
                        isLoading = false
                        if signInIntent && !exists {
                            errorMessage = "This account does not exist. Please sign up."
                        } else {
                            errorMessage = ""
                        }
                    }
                } catch {
                    print("Failed to check user existence: \(error)")
                    isLoading = false
                    errorMessage = "An error occurred while trying to verify the email."
                }
            }
        }
        
        func authenticateOrRegister(appState: AppState, rememberMe: Bool) {
            guard let userExists = userExists else { return }
            isLoading = true
            Task {
                do {
                    if userExists {
                        let result = try await authService.login(email: emailText, password: passwordText, userExists: userExists)
                        await MainActor.run {
                            guard let user = result?.user else {
                                errorMessage = "The password you entered is incorrect."
                                return
                            }
                            appState.currentUser = user
                            appState.storeRememberMe(remember: rememberMe)
                            errorMessage = ""
                        }
                    } else {
                        let result = try await authService.createUserAndAddToFirestore(email: emailText, password: passwordText)
                        await MainActor.run {
                            appState.currentUser = result.user
                            appState.storeRememberMe(remember: rememberMe)
                            errorMessage = ""
                        }
                    }
                    isLoading = false
                } catch {
                    print(error)
                    errorMessage = "\(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
        func resetForSignUp() {
            userExists = false
            isPasswordVisible = true
            signInIntent = false
            errorMessage = ""
        }
        func resetForSignIn() {
            userExists = true
            isPasswordVisible = true
            signInIntent = true
            errorMessage = ""
        }
    }
}

