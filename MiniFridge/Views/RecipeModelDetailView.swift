//
//  RecipeModelDetailView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-02.
//

import SwiftUI

struct RecipeModelDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var recipeViewModel: RecipeViewModel
    var recipeModel: RecipeModel
    
    var body: some View {
        
        ZStack {
            Color.theme.background.ignoresSafeArea(.all)
            NavigationStack {
                VStack {
                    Text(recipeModel.title)
                        .font(.system(size:28,weight:.medium))
                        .padding(.leading, 10)
                    List {
                        Section("Ingredients") {
                            ForEach(recipeModel.missedIngredients) {ingredient in
                                Text(ingredient.original)
                            }
                            ForEach(recipeModel.usedIngredients) {ingredient in

                                Text(ingredient.original)
                            }
                        }
                        Section("Instructions") {
                            ForEach(recipeModel.instructions?.steps ?? [],id: \.number) {instruction in
                                HStack {
                                    Text("\(instruction.number).")
                                        .font(.headline)
                                        .frame(width: 30, alignment: .leading)
                                        .foregroundColor(Color.theme.accent)
                                    Text(instruction.step)
                                        .font(.body)
                                        .foregroundColor(Color.theme.accent)
                                }
                                
                                
                            }
                        }
                        AsyncImage(url: URL(string:recipeModel.image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2))
                                        .shadow(radius: 5)
                                
                        }
                        placeholder: {
                            ProgressView()
                        }
                        
                    }.scrollContentBackground(.hidden)
                    .background(Color.theme.background)
                    .task {
                        await recipeViewModel.getRecipeInstructions(recipeId: recipeModel.id)
                    }
                }.background(Color.theme.background)
                
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                        
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
            
        }
        
        
        
    }
}

struct RecipeModelDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        let recipeViewModel = RecipeViewModel(profileViewModel: profileViewModel)
        let mockRecipeModel = RecipeModel(
            id: 12345,
            title: "Cranberry Apple Crisp",
            image: "https://img.spoonacular.com/recipes/640352-312x231.jpg",
            missedIngredients: [IngredientModel(id: 1, amount: 2, unit: "cups", name: "apples", original: "chunks of apples")],
            usedIngredients: [IngredientModel(id: 1, amount: 2, unit: "cups", name: "oranges", original: "chunks of oranges")],
            instructions: RecipeInstructions(steps: [Step(number: 1, step: "first step"),Step(number: 2, step: "second step")])
        )
        
        RecipeModelDetailView(recipeViewModel: recipeViewModel, recipeModel: mockRecipeModel)
    }
}

