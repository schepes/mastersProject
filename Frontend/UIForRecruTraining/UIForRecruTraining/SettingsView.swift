//
//  ChatListView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/1/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var isShowingProfileView = false

    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            Text("Settings")
                .font(.appTitle)
                .foregroundColor(Color("MainColor"))
                .padding(.bottom, 40)

            HStack {
                VStack(alignment: .leading) {
                    // Profile
                    Button(action: {
                        isShowingProfileView = true
                    }) {
                        HStack {
                            Image("ic-profile-blue")
                            Text(" Profile")
                                .font(.mediumEitheen)  // make sure to check your font case, it might be "mediumEighteen"
                                .foregroundColor(Color("MainColor"))
                        }
                        .padding(7)
                    }

                    // Other settings options
                    HStack {
                        Image("ic-info")
                        Text("About Us")
                            .font(.mediumEitheen) // typo correction: .mediumEitheen -> .mediumEighteen
                            .foregroundColor(Color("MainColor"))
                    }
                    .padding(7)

                    HStack {
                        Image("ic-question-mark")
                        Text("FAQ")
                            .font(.mediumEitheen)
                            .foregroundColor(Color("MainColor"))
                    }
                    .padding(7)

                    HStack {
                        Image("ic-book")
                        Text("Terms of Service")
                            .font(.mediumEitheen)
                            .foregroundColor(Color("MainColor"))
                    }
                    .padding(7)

                    Spacer().frame(height: 350)
                    Button(action: {
                        appState.logout()
                    }) {
                        Text("Logout")
                            .font(.mediumEitheen)
                            .foregroundColor(Color("MainColor"))
                            .underline()
                    }
                }
                .frame(width: 210, alignment: .leading)
                .padding(.leading, 40)
                
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .sheet(isPresented: $isShowingProfileView) {
            ProfileView()
        }
    }
}

#Preview {
    SettingsView()
}
