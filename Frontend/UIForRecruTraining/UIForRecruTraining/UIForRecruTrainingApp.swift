//
//  UIForRecruTrainingApp.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 12/31/23.
//

import SwiftUI

@main
struct UIForRecruTrainingApp: App {
    
    @ObservedObject var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath){
                    ChatListView()
                        .environmentObject(appState)
                }
                //ContentView()
            } else{
                AuthView()
                    .environmentObject(appState)
            }
        }
    }
}
