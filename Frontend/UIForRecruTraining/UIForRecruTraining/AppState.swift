//
//  AppState.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/1/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var navigationPath = NavigationPath()
    
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    init(){
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
