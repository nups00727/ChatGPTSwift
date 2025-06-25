//
//  AuthService.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    let db = Firestore.firestore()
   
    func checkUserExists(email: String) async throws -> Bool {
        let userRef = db.collection("users").whereField("email", isEqualTo: email).count
        let count = try await userRef.getAggregation(source: .server).count
        return Int(truncating: count) > 0
    }
    
    func login(email: String, password: String,
               userExists: Bool) async throws -> AuthDataResult? {
        
        guard !password.isEmpty else { return nil}
        
        if userExists {
           return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }
}
