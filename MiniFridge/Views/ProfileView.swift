//
//  ProfileView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-16.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var profileViewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            NavigationStack {
                VStack(spacing: 20) {
                    
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.theme.darkGreen)
                            .padding(.top, 40)
                        
                        HStack {
                            TextField("Name", text: $profileViewModel.name)
                                .foregroundColor(Color.theme.darkGreen)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                            
                            Button {
                                profileViewModel.toggleNameChange()
                            } label: {
                                Text("Update Name")
                                    .foregroundColor(Color.theme.darkGreen)
                                    .bold()
                                    .frame(width: 150, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.theme.mutedYellow)
                                    )
                                    .padding(.leading, 10)
                            }
                        }
                        .padding([.horizontal, .top], 20)
                        List {
                            if let user = profileViewModel.user {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Profile")
                                        .font(.largeTitle)
                                        .bold()
                                        .padding(.bottom, 10)
                                        .foregroundColor(Color.theme.accent)
                                    
                                    HStack {
                                        Text("Name:")
                                            .bold()
                                            .foregroundColor(Color.theme.darkGreen)
                                        Spacer()
                                        Text(user.name?.capitalized ?? "")
                                            .foregroundColor(Color.theme.darkGreen)
                                    }
                                    
                                    HStack {
                                        Text("Email:")
                                            .bold()
                                            .foregroundColor(Color.theme.darkGreen)
                                        Spacer()
                                        Text(user.email ?? "")
                                            .foregroundColor(Color.theme.darkGreen)
                                    }
                                }
                            } else {
                                VStack {
                                    ProgressView()
                                }
                            }
                        }
                        .task {
                            try? await profileViewModel.loadCurrentUser()
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.theme.background)
                    }
                    .background(Color.theme.background)
                    
                    
                }
                .padding(.vertical, -10)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                do {
                                    try profileViewModel.signOut()
                                    showSignInView = true
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundColor(Color.theme.darkGreen)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
            

#Preview {
    ProfileView(showSignInView: .constant(false))
}
