//
//  RecipeViewModel.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-05.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [RecipeModel] = []

    
    
    private let spoonacularAPIKey = Bundle.main.infoDictionary!["SPOONACULAR_API_KEY"] as! String
    private let baseURL = "https://api.spoonacular.com/"
    private var profileViewModel: ProfileViewModel

    init(profileViewModel: ProfileViewModel) {
            self.profileViewModel = profileViewModel
        }
    
    func getRecipeInstructions(recipeId: Int) async {
        guard let url = URL(string: "\(baseURL)recipes/\(recipeId)/analyzedInstructions?&apiKey=\(spoonacularAPIKey)") else {return}
        
        do {
            let data = try await downloadData(fromURL: url)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString!)
            print("SUCCESS: RECIPE INSTRUCTIONS!!!!!!!!!!!!")
            guard let newInstructions = try? JSONDecoder().decode([RecipeInstructions].self, from: data)[0] else { return }
            if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
                recipes[index].instructions = newInstructions
            }

        } catch {
            print("No Data Returned")
        }
    }
    
    func getRecipes() async {
        
        var userIngredients = ""

        guard let user = profileViewModel.user else {
                print("No authenticated user found")
                return
            }

        userIngredients = (user.ingredients?.map { $0.name } ?? []).joined(separator: ",+")

        print("USER INGREDIENTS: \(userIngredients)")
        
        guard let url = URL(string: "\(baseURL)recipes/findByIngredients?number=5&ranking=1&ignorePantry=true&ingredients=\(userIngredients)&apiKey=\(spoonacularAPIKey)") else {return}

        do {
            let data = try await downloadData(fromURL: url)
            let jsonString = String(data: data, encoding: .utf8)
            print("SUCCESS: RECIPES")
            print(jsonString!)
            guard let newRecipes = try? JSONDecoder().decode([RecipeModel].self, from: data) else { return }
                self.recipes = newRecipes

        } catch {
            print("No Data Returned")
        }
        
    }
    
    private func downloadData(fromURL url: URL) async throws -> Data {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
            return data
        }
}
