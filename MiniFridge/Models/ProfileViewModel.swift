//
//  ProfileViewModel.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-05.
//

import Foundation
import SwiftUI


@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: StoredUser? = nil
    @Published var name = ""
    
    func loadCurrentUser() async throws {
        self.user = nil
        print("Loading current user...")
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        print("Authenticated user ID: \(authDataResult.uid)")
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        print("User loaded: \(String(describing: self.user))")
    }
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        self.user = nil
    }
    
    func toggleNameChange() {
        guard let user else { return }
        guard !name.isEmpty else {
            print("No name entered")
            return
        }
        
        Task {
            try await UserManager.shared.updateUserName(userId: user.userId, name: name)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
        
    }
    
    func addUserIngredient(ingredient: Ingredient) {
        guard let user else { return }
        Task {
            try await UserManager.shared.addUserIngredient(userId: user.userId, ingredient: ingredient)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeUserIngredient(ingredient: Ingredient) {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeUserIngredient(userId: user.userId, ingredient: ingredient)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}
