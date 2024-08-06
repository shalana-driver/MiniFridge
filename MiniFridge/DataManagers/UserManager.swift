//
//  UserManager.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-27.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct StoredUser : Codable {
    let userId : String
    let email : String?
    let photoURL : String?
    let dateCreated : Date?
    let name : String?
    let ingredients : [Ingredient]?

    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.name = ""
        self.ingredients = nil
    }
    
    init(userId : String, email : String? = nil, photoURL : String? = nil, dateCreated : Date? = nil, name : String? = nil, ingredients : [Ingredient]? = nil) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.name = name
        self.ingredients = ingredients
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoURL = "photo_url"
        case dateCreated = "date_created"
        case name = "name"
        case ingredients = "ingredients"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.ingredients = try container.decodeIfPresent([Ingredient].self, forKey: .ingredients)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.ingredients, forKey: .ingredients)
    }
}


final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("Users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: StoredUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> StoredUser {
        try await userDocument(userId: userId).getDocument(as: StoredUser.self)
    }
    
    
    func updateUserName(userId: String, name: String) async throws {
        let data: [String:Any] = [
            StoredUser.CodingKeys.name.rawValue : name
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    private let encoder : Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder : Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func addUserIngredient(userId: String, ingredient: Ingredient) async throws {
        guard let data = try? encoder.encode(ingredient) else {
            throw URLError(.badURL)
        }
        let dict: [String:Any] = [
            StoredUser.CodingKeys.ingredients.rawValue : FieldValue.arrayUnion([data])
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
    func removeUserIngredient(userId: String, ingredient: Ingredient) async throws {
        let encoder = JSONEncoder()
            guard let data = try? encoder.encode(ingredient),
                  let ingredientDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw URLError(.badURL)
            }
        let dict: [String:Any] = [
            StoredUser.CodingKeys.ingredients.rawValue : FieldValue.arrayRemove([ingredientDict])
        ]
        try await userDocument(userId: userId).updateData(dict)
    }
    
}
