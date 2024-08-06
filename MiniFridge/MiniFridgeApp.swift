//
//  MiniFridgeApp.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-13.
//

import SwiftUI
import Firebase

@main
struct MiniFridgeApp: App {
    @StateObject var ingredientsDataManager = IngredientsDataManager()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(ingredientsDataManager)
        }
    }
}
