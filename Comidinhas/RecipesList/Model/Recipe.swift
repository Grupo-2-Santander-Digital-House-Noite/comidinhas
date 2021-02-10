//
//  Recipe.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import Foundation


struct RecipeResults: Codable {
    var results: [Recipe]
}

typealias BulkRecipeResults = [Recipe]

struct Recipe: Codable {
    var id: Int?
    var name: String?
    var time: Int?
    var category: [String]?
    var servings: Int?
    var image: String?
    var ingredients: [Ingredients]?
    var stepsSection: [StepsSection]
    
    var categoryString: String {
        get {
            
            if self.category?.count == 1 {
                return self.category?[0] ?? ""
            }
            
            guard let categorias = self.category else {
                return "N/A"
            }
            
            var categoriasString = ""
            var count = 0;
            for categoria in categorias {
                if count == 0 {
                    categoriasString = categoria
                    count += 1
                } else {
                    categoriasString = "\(categoriasString), \(categoria)"
                }
            }
            return categoriasString
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "title"
        case time = "readyInMinutes"
        case category = "dishTypes"
        case servings = "servings"
        case image = "image"
        case ingredients = "extendedIngredients"
        case stepsSection = "analyzedInstructions"
    }
}
