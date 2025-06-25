//
//  AuthViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//
import SwiftUI

@Observable class AuthViewModel {
    var emailText: String = ""
    var passwordText: String = ""
    
    var isLoading = false
    var isPasswordVisible = false
    var userExists = false
    
    let authService = AuthService()
    
    func authenticate(appState: AppState) {
        isLoading = true
        
        Task {
            do {
                if isPasswordVisible {
                   let result = try await authService.login(email: emailText,
                                                password: passwordText, userExists: userExists)
                    await MainActor.run {
                        guard let result = result else { return }
                        appState.currentUser = result.user
                    }
                } else {
                    userExists = try await authService.checkUserExists(email: emailText)
                    isPasswordVisible = true
                    isLoading = false
                }
            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}
