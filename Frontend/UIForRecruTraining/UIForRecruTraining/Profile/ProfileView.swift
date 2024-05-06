//
//  ProfileView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    @State var apiKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    
    var body: some View {
        List {
            Section("OpenAI API Key"){
                TextField("Enter API Key", text: $apiKey) {
                    UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
