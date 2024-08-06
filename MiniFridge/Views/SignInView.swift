//
//  SignInView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-15.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var signInViewModel = SignInViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            VStack {
                Text("MiniFridge")
                    .foregroundColor(.accent)
                    .font(.system(size: 40,weight: .bold))
                    .padding()
                VStack {
                    TextField("email",text: $signInViewModel.email)
                        .foregroundColor(Color.theme.darkGreen)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal,50)
                        .padding(.bottom,10)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    SecureField("password",text:$signInViewModel.password)
                        .foregroundColor(Color.theme.darkGreen)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal,50)
                        .padding(.top,10)
                        
                }.padding(.top,100)
                .padding(.bottom,20)
                if !signInViewModel.errorMessage.isEmpty {
                    Text(signInViewModel.errorMessage)
                        .foregroundColor(Color.theme.darkGreen)
                        .padding(.horizontal,50)
                        .padding(.bottom,20)
                }
                
                HStack {
                    Button{
                        Task {
                            await signInViewModel.signIn()
                            if signInViewModel.errorMessage.isEmpty {
                                try? await profileViewModel.loadCurrentUser()
                                showSignInView = false
                            }
                        }
                    } label : {
                        Text("Sign In")
                            .foregroundColor(Color.theme.darkGreen)
                            .bold()
                            .frame(width:100,height:40)
                            .background(
                                RoundedRectangle(cornerRadius: 15,style: .continuous)
                                    .fill(Color.theme.mutedYellow)
                            )
                    }.padding(.trailing,10)
                    
                    Button {
                        Task {
                            await signInViewModel.signUp()
                            if signInViewModel.errorMessage.isEmpty {
                                try? await profileViewModel.loadCurrentUser()
                                showSignInView = false
                            }
                        }
                        
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(Color.theme.darkGreen)
                            .bold()
                            .frame(width:100,height:40)
                            .background(
                                RoundedRectangle(cornerRadius: 15,style: .continuous)
                                    .fill(.linearGradient(colors: [Color.theme.lightGreen,Color.theme.lightGreen], startPoint: .top, endPoint: .bottomTrailing))
                            )
                        
                    }.padding(.leading,10)
                }
                Spacer()
            }
        }  
    }
}


#Preview {
    SignInView(showSignInView: .constant(false))
}

