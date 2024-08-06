//
//  SignInViewModel.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-08-05.
//

import Foundation
import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    func signUp() async {
        errorMessage = ""
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter an email and password"
            return
        }
        do {
            let authDataResultModel = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let user = StoredUser(auth: authDataResultModel)
            try await UserManager.shared.createNewUser(user: user)
        } catch {
            errorMessage = "\(error.localizedDescription)"
        }
    }
    func signIn() async {
        errorMessage = ""
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password"
            return
        }
        do {
            try await AuthenticationManager.shared.signIn(email: email, password: password)
        } catch {
            errorMessage = "Email or password is incorrect"
        }
    }
}
