//
//  RecipeDataProvider.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 02/11/20.
//

import Foundation

class RecipesWebService {
    
    public var recipes: [Recipe] = []
    
    static var shared: RecipesWebService = { () -> RecipesWebService in
        let instance = RecipesWebService()
        instance.loadRecipes()
        
        return instance
    }()
    
    private init() {
        
    }
    
    func loadRecipes() -> Void {
        
        do {
            let path: String = Bundle.main.path(forResource: "recipes", ofType: "json") ?? ""
            let url: URL = URL(fileURLWithPath: path)
            let data: Data = try Data(contentsOf: url)
            let recipes: RecipeResults = try JSONDecoder().decode(RecipeResults.self, from: data)
            
            self.recipes = recipes.results.filter({ (recipe) -> Bool in
                return recipe.stepsSection.count > 0
            })
            
        } catch {
            print(error)
        }
        
    }
    
}
