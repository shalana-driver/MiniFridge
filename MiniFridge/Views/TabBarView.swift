//
//  TabBarView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-15.
//

import SwiftUI

struct TabBarView: View {
    
    @State var selectedTab = 0
    @Binding var showSignInView: Bool
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View{
        ZStack{
            TabView(selection: $selectedTab){
                
                HomePageView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)
                NewRecipeView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Recipes")
                    }.tag(1)
                ProfileView(showSignInView: $showSignInView)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }.tag(2)
                
            }
            .ignoresSafeArea(.all)
            .tint(Color.theme.darkGreen)
        }
        .fullScreenCover(isPresented: $showSignInView, onDismiss: {
            Task {

                try? await profileViewModel.loadCurrentUser()
                selectedTab = 0
            }
        }) {
            NavigationStack {
                SignInView(showSignInView: $showSignInView)
            }
        }
    }
    
}

#Preview {
    TabBarView(showSignInView: .constant(false))
        .environmentObject(IngredientsDataManager())
}
