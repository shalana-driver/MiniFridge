//
//  NewRecipeView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-15.
//

import SwiftUI

struct Step: Codable {
    let number: Int
    let step: String
    
}

struct RecipeInstructions: Codable {
    let steps: [Step]
}

struct IngredientModel: Identifiable, Codable {
    let id: Int
    let amount: Double
    let unit: String
    let name: String
    let original: String
}

struct RecipeModel: Identifiable, Codable {
    let id: Int
    let title: String
    let image: String
    let missedIngredients: [IngredientModel]
    let usedIngredients: [IngredientModel]
    var instructions: RecipeInstructions?
    
}

struct NewRecipeView: View {
    
    @EnvironmentObject var ingredientsDataManager: IngredientsDataManager
    
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var recipeViewModel: RecipeViewModel
    
    @State private var selectedRecipe: RecipeModel? = nil
    @State private var isIngredientListPresented = false
    
    init() {
        let profileViewModel = ProfileViewModel()
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
        _recipeViewModel = StateObject(wrappedValue: RecipeViewModel(profileViewModel: profileViewModel))
        }
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                
                List {

                    RecipeTableView(recipes: recipeViewModel.recipes, recipeViewModel: recipeViewModel,length: 5)
                    
                }.scrollContentBackground(.hidden)
                .background(Color.theme.background)
                .navigationTitle("Recipes")
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
                .task {
                    try? await profileViewModel.loadCurrentUser()
                    if profileViewModel.user != nil {
                        await recipeViewModel.getRecipes()
                    }
                }
                if let selectedRecipe = selectedRecipe {
                    NavigationLink(destination: RecipeModelDetailView(recipeViewModel: recipeViewModel,recipeModel: selectedRecipe), isActive: Binding(get: { self.selectedRecipe != nil }, set: { if !$0 { self.selectedRecipe = nil } })) {
                        EmptyView()
                    }
                }
            }
            
        }.fullScreenCover(isPresented: $isIngredientListPresented) {
            
            IngredientListView(profileViewModel: profileViewModel,recipeViewModel: RecipeViewModel(profileViewModel: profileViewModel), ingredients: ingredientsDataManager.ingredients)
        }
    }
}


#Preview {
    NewRecipeView()
        .environmentObject(IngredientsDataManager())
}
