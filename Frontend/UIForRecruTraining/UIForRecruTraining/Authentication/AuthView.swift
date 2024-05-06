
//
//  AuthView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/3/24.
//

import SwiftUI


struct AuthView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = false
    @State private var shouldNavigate: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                
                Spacer().frame(height: 100)
                
                Image("ic-logo")
                //                .padding()
                
                Text("Mock Interview")
                    .font(.appTitle)
                    .foregroundColor(Color("MainColor"))
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)  // Allows text to wrap in the view
                }
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10) // Adjusted corner radius
                        .fill(Color.white)
                        .frame(height: 70) // Adjusted height for the rectangle
                        .shadow(radius: 1)
                    
                    Text("Email")
                        .foregroundColor(Color("LoginLetters"))
                        .font(.loginInfo)
                        .padding([.leading, .top], 10) // Adjust padding to align the label correctly
                    
                    TextField("", text: $authViewModel.emailText)
                    // Adjust for label
                        .padding(.top, 30)
                        .padding(.horizontal, 10)
                        .frame(height: 60)
                        .font(.loginInfo)
                        .foregroundColor(Color("MainColor"))
                }
                .padding(.horizontal, 30)
                .frame(height: 150)
                if authViewModel.isPasswordVisible {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10) // Adjusted corner radius
                            .fill(Color.white)
                            .frame(height: 70) // Adjusted height for the rectangle
                            .shadow(radius: 1)
                        
                        Text("Password")
                            .foregroundColor(Color("LoginLetters"))
                            .font(.loginInfo)
                            .padding([.leading, .top], 10) // Adjust padding to align the label correctly
                        HStack{
                            if isPasswordVisible {
                                TextField("", text: $authViewModel.passwordText)
                                // Adjust for label
                                    .padding(.top, 30)
                                    .padding(.horizontal, 10)
                                    .frame(height: 60)
                                    .font(.loginInfo)
                                    .foregroundColor(Color("MainColor"))
                            } else {
                                SecureField("", text: $authViewModel.passwordText)
                                // Adjust for label
                                    .padding(.top, 30)
                                    .padding(.horizontal, 10)
                                    .frame(height: 60)
                                    .font(.loginInfo)
                                    .foregroundColor(Color("MainColor"))
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(isPasswordVisible ? "ic-eye-on" : "ic-eye-off")
                                    .padding([.top, .trailing])
                            }
                        }
                        
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 0)
                    
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack {
                                Image(rememberMe ? "ic-filled-rectangle" : "ic-empty-rectangle")
                                
                                Text("Remember me")
                                    .font(.loginInfo)
                                    .foregroundColor(Color("MainColor"))
                                
                            }
                            .padding(30)
                            .padding(.vertical, 10)
                        }
                        
                        Spacer()
                        
                        if authViewModel.userExists == true && authViewModel.isPasswordVisible {
                            Button("Forgot password") {
                                // Handle forgot password action
                            }
                            .font(.boldFourteen)
                            .foregroundColor(Color("MainColor"))
                            .padding(.horizontal, 30)
                            .frame(height: 100)
                        }
                        
                    }
                }
                
                Button(action: {
                    if authViewModel.isPasswordVisible {
                        authViewModel.authenticateOrRegister(appState: appState, rememberMe: rememberMe)
                    } else {
                        authViewModel.checkExistenceOrProceed()
                    }
                }) {
                    ZStack{
                        Image("bt-sign-in")
                        Text(authViewModel.userExists == true ? "Sign In" : "Sign Up")
                            .font(.boldEitheen)
                            .foregroundColor(Color("Background"))
                    }
                }
                if authViewModel.isPasswordVisible && authViewModel.userExists == true {
                    HStack{
                        Text("Don't have an account? ")
                            .font(.loginInfo)
                            .foregroundColor(Color("MainColor"))
                        
                        Button("Sign Up") {
                            authViewModel.resetForSignUp()
                        }
                        .font(.boldFourteen)
                        .foregroundColor(Color("MainColor"))
                    }
                    .padding()
                }
                
                if authViewModel.isPasswordVisible && authViewModel.userExists == false {
                    HStack{
                        Text("Already have an account? ")
                            .font(.loginInfo)
                            .foregroundColor(Color("MainColor"))
                        
                        Button("Sign In") {
                            authViewModel.resetForSignIn()
                        }
                        .font(.boldFourteen)
                        .foregroundColor(Color("MainColor"))
                    }
                    .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
            .onTapGesture {
                    self.dismissKeyboard()
                }
        }
    }
}

#Preview {
    AuthView()
}

