//
//  IngredientTableView.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-05.
//

import Foundation
import SwiftUI

struct IngredientView: View {
    var ingredient: Ingredient
    
    var body: some View {
        HStack {
            Image(systemName: "leaf.fill")
                .foregroundColor(Color.theme.mediumGreen)
                .padding(.trailing, 5)
            Text(ingredient.name)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
        }.padding(.vertical,5)

    }
}

struct IngredientTableView: View {
    var ingredients: [Ingredient]
    var user: StoredUser
    
    var body: some View {
        Section("My MiniFridge") {
            ForEach(user.ingredients ?? [], id: \.id) { ingredient in
                IngredientView(ingredient: ingredient)
            }
        }
    }
}
