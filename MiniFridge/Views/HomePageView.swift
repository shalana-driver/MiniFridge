//
//  ContentView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-13.
//

import SwiftUI

struct HomePageView: View {
    
    @EnvironmentObject var ingredientsDataManager: IngredientsDataManager
    @StateObject private var profileViewModel = ProfileViewModel()
    @State var isIngredientListPresented = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            NavigationStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isIngredientListPresented = true
                        }) {
                            Text("Update Ingredients")
                                .foregroundColor(Color.theme.darkGreen)
                                .bold()
                                .frame(width: 220, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(Color.theme.mediumGreen)
                                )
                        }
                        Spacer()
                    }
                    List {
                        if let user = profileViewModel.user {
                            IngredientTableView(ingredients: user.ingredients ?? [], user: user)

                        } else {
                            ProgressView()
                        }
                        
                        
                    }
                    .task {
                        try? await profileViewModel.loadCurrentUser()
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.theme.background)
                    .navigationTitle("MiniFridge")
                    .foregroundColor(Color.theme.accent)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if let user = profileViewModel.user {
                                HStack {
                                    Text("\((user.name ?? "").description.capitalized)")
                                        .font(.headline)
                                        .foregroundColor(Color.theme.darkGreen)
                                    Image(systemName: "person.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color.theme.darkGreen)
                                }.padding(.horizontal, 20)
                            }
                        }
                    }
                    
                }.background(Color.theme.background)
               
            }
            .fullScreenCover(isPresented: $isIngredientListPresented) {
                IngredientListView(profileViewModel: profileViewModel, recipeViewModel: RecipeViewModel(profileViewModel: profileViewModel), ingredients: ingredientsDataManager.ingredients)
            }
        }
    }
}

#Preview {
    HomePageView()
        .environmentObject(IngredientsDataManager())
}
