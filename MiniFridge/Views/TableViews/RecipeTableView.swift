//
//  RecipeTableView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-05.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    let recipe: RecipeModel
    let recipeViewModel: RecipeViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationLink(destination: RecipeModelDetailView(recipeViewModel: recipeViewModel, recipeModel: recipe)) {
                HStack {
                    AsyncImage(url: URL(string: recipe.image)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 10)
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .shadow(radius: 2)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width / 4, height: geometry.size.width / 4)
                    .clipped()
                    Text(recipe.title)
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
}

struct RecipeTableView: View {
    let recipes: [RecipeModel]
    let recipeViewModel: RecipeViewModel
    let length: Int
    var title: String? = nil
    
    var body: some View {
        Section(title ?? "") {
            ForEach(recipeViewModel.recipes.prefix(length)) { recipe in
                    RecipeView(recipe: recipe, recipeViewModel: recipeViewModel)
            }
        }.padding(.bottom,50)
  
    }
}
