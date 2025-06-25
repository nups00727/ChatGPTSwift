//
//  AppState.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//
import Firebase
import FirebaseAuth
import SwiftUI

@Observable class AppState {
    var currentUser: User?
    var navigationPath = NavigationPath()
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    init() {
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
