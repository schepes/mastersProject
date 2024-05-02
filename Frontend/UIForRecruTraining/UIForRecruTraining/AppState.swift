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
    
    init(){
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
