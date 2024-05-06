//
//  AuthService.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/3/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    let db = Firestore.firestore()

    // Add the new user to Firestore after creating an account
    func createUserAndAddToFirestore(email: String, password: String) async throws -> AuthDataResult {
        // Create user with email and password
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

        // After a successful creation, add user data to Firestore
        try await addUserToFirestore(uid: authResult.user.uid, email: email)

        return authResult
    }

    private func addUserToFirestore(uid: String, email: String) async throws {
        let userRef = db.collection("users").document(uid) // Use UID as document key
        try await userRef.setData([
            "email": email
        ])
    }

    // Check if user exists in Firestore
    func checkUserExists(email: String) async throws -> Bool {
        let querySnapshot = try await db.collection("users").whereField("email", isEqualTo: email).getDocuments()
        return querySnapshot.documents.count > 0
    }

    // Logic for user login remains the same
    func login(email: String, password: String, userExists: Bool) async throws -> AuthDataResult? {
        guard !password.isEmpty else {return nil}
        
        if userExists {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            // This should not be called if the user does not exist
            return nil
        }
    }
}
