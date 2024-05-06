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
    
    
    func storeRememberMe(remember: Bool) {
        UserDefaults.standard.set(remember, forKey: "rememberMe")
    }
    
    func loadRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: "rememberMe")
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            storeRememberMe(remember: false)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    init(){
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        let rememberMe = loadRememberMe()
        if rememberMe, let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        } else {
            self.currentUser = nil
        }
    }
}
