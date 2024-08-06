//
//  IngredientListView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-14.
//

import SwiftUI

struct IngredientListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var ingredientsDataManager: IngredientsDataManager
    @StateObject var recipeViewModel: RecipeViewModel
    @State private var searchText = ""

    var ingredients: [Ingredient]
    
    private var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return ingredientsDataManager.ingredients
        } else {
            return ingredientsDataManager.ingredients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func ingredientIsSelected(ingredient: Ingredient) -> Bool {
            profileViewModel.user?.ingredients?.contains(where: { $0.id == ingredient.id }) == true
        }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    TextField("search ingredients...", text: $searchText)
                        .padding(.horizontal,20)
                                        .foregroundColor(Color.theme.darkGreen)
                                        .textFieldStyle(.roundedBorder)
                    List {
                        
                        ForEach(filteredIngredients.sorted(by: {
                            if ingredientIsSelected(ingredient: $0) != ingredientIsSelected(ingredient: $1) {
                                return ingredientIsSelected(ingredient: $0)
                            } else {
                                return $0.name < $1.name
                            }
                        }), id: \.id) { ingredient in
                            Button(action: {
                                if ingredientIsSelected(ingredient: ingredient) {
                                    profileViewModel.removeUserIngredient(ingredient: ingredient)
                                } else {
                                    profileViewModel.addUserIngredient(ingredient: ingredient)
                                }
                            }) {
                                HStack {
                                    IngredientView(ingredient:ingredient)
                                    Spacer()
                                    Image(systemName: ingredientIsSelected(ingredient: ingredient) ? "checkmark.square" : "square")
                                }
                            }
                            .foregroundColor(ingredientIsSelected(ingredient: ingredient) ? Color.theme.accent : Color.theme.accent.opacity(0.5))
                        }
                        
                    }.navigationTitle("My MiniFridge")
                    .scrollContentBackground(.hidden)
                    .background(Color.theme.background)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {

                                Task {
                                    dismiss()
                                }
                                
                            }) {
                                HStack {
                                    Image(systemName: "multiply")
                                }.padding(.trailing,20)
                                    .foregroundColor(Color.theme.accent)
                            }
                        }
                    }
                }.background(Color.theme.background)
            }
        }
 
    }
    
}

#Preview {
    IngredientListView(profileViewModel: ProfileViewModel(),recipeViewModel: RecipeViewModel(profileViewModel: ProfileViewModel()),ingredients: IngredientsList.ingredientsTest)
        .environmentObject(IngredientsDataManager())
}
