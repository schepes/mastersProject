//
//  SettingsView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/1/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        VStack {
            Spacer().frame(height: 30)
            Text("Settings")
                .font(.appTitle)
                .foregroundColor(Color("MainColor"))
                .padding(.bottom, 40)
            HStack {
                VStack(alignment: .leading) {

                    HStack {
                        Image("ic-settings-small")
                        Text("Profile")
                            .font(.mediumEitheen)
                            .foregroundColor(Color("MainColor"))
                       
                    }
                    .padding(7)

                    HStack {
                        Image("ic-info")
                        Text("About Us")
                            .font(.mediumEitheen)
                            .foregroundColor(Color("MainColor"))
                    }
                    .padding(7)

                    HStack {
                        Image("ic-question-mark")
                        Text("FAQ")                       .font(.mediumEitheen)
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
                    HStack {
                        
                        Button (action: {
                            print("Logout tapped")
                        }){
                            HStack {
                                Text("Logout")
                                    .font(.mediumEitheen)
                                    .foregroundColor(Color("MainColor"))
                                    .underline()
                            }
                        }
                    }
                    
                }
                .frame(width: 210, alignment: .leading)
                .padding(.leading, 40)
                
                Spacer()
            }
            Spacer()
            
        
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color("Background"))
       
        
    }
    
}

#Preview {
    SettingsView()
}
