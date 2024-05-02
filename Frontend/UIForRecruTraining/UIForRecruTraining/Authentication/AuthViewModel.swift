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
        
        @Published var isLoading = false
        @Published var isPasswordVisible = false
        @Published var userExists = false
        
        let authService = AuthService()
        func authenticate(appState: AppState){
            isLoading = true
            Task {
                do {
                    if isPasswordVisible {
                        let result = try await authService.login(email: emailText, password: passwordText, userExists: userExists)
                        await MainActor.run (body:{
                            guard let result = result else { return }
                            
                            appState.currentUser = result.user
                            
                        })
                    } else{
                        userExists = try await authService.checkUserExists(email: emailText)
                        isPasswordVisible = true
                    }
                    isLoading = false
                } catch {
                    print(error)
                    await MainActor.run {
                        isLoading = false
                    }
             
                }
            }
        }
    }
}
