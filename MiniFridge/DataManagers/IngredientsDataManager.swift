//
//  IngredientsDataManager.swift
//  MiniFridge
//
//  Created by Shalana Driver on 2024-07-19.
//

import SwiftUI
import Firebase

class IngredientsDataManager: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    
    init() {
        fetchIngredients()
    }
    
    func fetchIngredients() {
        ingredients.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Ingredients")
        
        // The following code was used to fill the Firebase database "Ingredients" with ingredients that user's can select from
        
//        let ingredientsList = [
//            "Apples", "Apricots", "Artichokes", "Asparagus", "Avocados", "Bacon", "Bananas", "Barley", "Basil",
//            "Beans", "Beef", "Beets", "Bell Peppers", "Black Beans", "Blackberries", "Blueberries", "Bok Choy",
//            "Bread", "Broccoli", "Brown Rice", "Brussels Sprouts", "Butter", "Buttermilk", "Cabbage", "Carrots",
//            "Cauliflower", "Celery", "Cheese", "Cherries", "Chicken", "Chickpeas", "Chives", "Cilantro", "Cinnamon",
//            "Clams", "Cocoa Powder", "Coconut Milk", "Cod", "Coffee", "Corn", "Couscous", "Cranberries",
//            "Cream Cheese", "Cucumbers", "Cumin", "Curry Powder", "Dill", "Dried Fruit", "Duck", "Edamame", "Eggs",
//            "Eggplant", "Fennel", "Feta Cheese", "Fish Sauce", "Flour", "Garlic", "Ginger", "Goat Cheese",
//            "Grapes", "Green Beans", "Green Onions", "Ground Beef", "Halibut", "Ham", "Heavy Cream", "Honey",
//            "Iceberg Lettuce", "Jalapenos", "Kale", "Ketchup", "Kiwi", "Lamb", "Leeks", "Lemon Juice", "Lemons",
//            "Lentils", "Lettuce", "Lime Juice", "Limes", "Maple Syrup", "Margarine", "Mayonnaise", "Milk", "Mint",
//            "Mixed Greens", "Molasses", "Mushrooms", "Mustard", "Nutmeg", "Oatmeal", "Olive Oil", "Olives", "Onions",
//            "Oranges", "Oregano", "Pancetta", "Paprika", "Parsley", "Parsnips", "Peaches", "Peanut Butter",
//            "Peanuts", "Pears", "Peas", "Pecans", "Pepper", "Pine Nuts", "Pineapple", "Pinto Beans", "Pita Bread",
//            "Plums", "Pork", "Potatoes", "Prawns", "Prosciutto", "Quinoa", "Radishes", "Raisins", "Raspberries",
//            "Red Bell Peppers", "Red Cabbage", "Red Onions", "Rhubarb", "Rice", "Rice Vinegar", "Romaine Lettuce",
//            "Rosemary", "Sage", "Salmon", "Salt", "Sardines", "Sausage", "Scallions", "Sea Salt", "Sesame Oil",
//            "Shallots", "Shrimp", "Snap Peas", "Snow Peas", "Sour Cream", "Soy Sauce", "Spinach", "Squash", "Steak",
//            "Strawberries", "Sugar", "Sunflower Oil", "Sweet Potatoes", "Swiss Chard", "Tahini", "Thyme", "Tilapia",
//            "Tofu", "Tomatoes", "Trout", "Tuna", "Turkey", "Vanilla Extract", "Vinegar", "Walnuts", "Watermelon",
//            "Wheat Flour", "White Beans", "White Vinegar", "Whole Wheat Bread", "Wild Rice", "Worcestershire Sauce",
//            "Yam", "Yeast", "Yogurt", "Zucchini", "Anise", "Arrowroot", "Arugula", "Baby Spinach", "Baking Powder",
//            "Baking Soda", "Bay Leaves", "Black Olives", "Brown Sugar", "Capers", "Caraway Seeds", "Cardamom",
//            "Cashews", "Cayenne Pepper", "Chia Seeds", "Chilli Powder", "Chipotle Peppers", "Cloves", "Coconut",
//            "Cornmeal", "Cornstarch", "Cranberry Sauce", "Croutons", "Dried Basil", "Dried Oregano", "Dried Thyme",
//            "Garam Masala", "Grape Tomatoes"
//        ]
//        
//        for ingredient in ingredientsList {
//            let newDocument = ref.document()
//            newDocument.setData(["id": newDocument.documentID, "name": ingredient]) { error in
//                if let error = error {
//                    print("Error adding document: \(error)")
//                } else {
//                    print("Document added with ID: \(newDocument.documentID)")
//                }
//            }
//        }
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""                    
                    
                    let ingredient = Ingredient(id: id, name: name)
                    self.ingredients.append(ingredient)
                }
            }
        }
    }
    
    
}



struct Ingredient: Identifiable, Codable {

    let id: String
    let name: String
}

struct IngredientsList {
    static let ingredientsTest = [
        Ingredient(id: "1",name: "Carrot"),
        Ingredient(id: "2",name: "Apple"),
        Ingredient(id: "3",name: "Onion"),
        Ingredient(id: "4",name: "Milk"),
        Ingredient(id: "5",name: "Butter"),
        Ingredient(id: "6",name: "Garlic"),
        Ingredient(id: "7",name: "Pasta"),
        Ingredient(id: "8",name: "Potato"),
        Ingredient(id: "9",name: "Eggs"),
        Ingredient(id: "10",name: "Chocolate Chips"),
        Ingredient(id: "11",name: "Salt"),
        Ingredient(id: "12",name: "Rosemary"),
    ]
}

