//
//  ContentView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 12/31/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "chat"  // Assume "chat" is the default selected tab

    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.04, green: 0.27, blue: 0.6, alpha: 1)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Image("ic-settings")
                        .renderingMode(.template)
                        .foregroundColor(selectedTab == "settings" ? Color("AccentColor") : Color.white)
                }
                .tag("settings")

            NavigationView {
                ChatView()
            }
            .tabItem {
                Image("ic-chat-bubble")
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == "chat" ? Color("AccentColor") : Color.white)
            }
            .tag("chat")
            
            AnalyticsView()
                .tabItem {
                    Image("ic-analytics")
                        .renderingMode(.template)
                        .foregroundColor(selectedTab == "analytics" ? Color("AccentColor") : Color.white)
                }
                .tag("analytics")
        }
    }
}



#Preview {
    ContentView()
}
