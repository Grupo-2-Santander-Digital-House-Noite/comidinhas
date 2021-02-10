//
//  RecipeDataProvider.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 02/11/20.
//

import Foundation

class RecipesWebService {
    
    private var worker: RecipesWorker?
    public var recipes: [Recipe] = []
    public var lastFilter: [RecipeFilter] = []
    public var finishedRequest = true
    
    static var shared: RecipesWebService = { () -> RecipesWebService in
        let instance = RecipesWebService()
        
        return instance
    }()
    
    private init() {
        worker = RecipesWorker()
    }
    
    func with(ids: [Int]) -> [Recipe] {
        return self.recipes.filter { (recipe) -> Bool in
            return ids.contains(recipe.id ?? 0)
        }
    }
    
    func with(ids: [Int], completion: @escaping ([Recipe]) -> Void,  failure: @escaping (Error) -> Void) {
        
        let worker = RecipesWorker()
        worker.getRecipesWith(ids: ids) { (recipes) in
            completion(recipes)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func loadRecipes() -> Void {
        
        do {
            let path: String = Bundle.main.path(forResource: "recipes", ofType: "json") ?? ""
            let url: URL = URL(fileURLWithPath: path)
            let data: Data = try Data(contentsOf: url)
            let recipes: RecipeResults = try JSONDecoder().decode(RecipeResults.self, from: data)
            
            var ids: [Int] = [];
            self.recipes = recipes.results.filter({ (recipe) -> Bool in
                return recipe.stepsSection.count > 0
            }).filter({ (recipe) -> Bool in
                guard let _id = recipe.id else { return false }
                if ids.contains(_id) {
                    return false
                }
                ids.append(_id)
                return true
            })
            
        } catch {
            print(error)
        }
        
    }
    
    func loadRecipesListWithUrl(url: String, completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) {
    
        self.worker?.getRecipesWithUrl(urlTeste: url) { (recipes, error) in
            
            if let _recipes = recipes {
                
                self.recipes = _recipes.results
                completionHandler(true, nil)
            }else{
                
                completionHandler(false, error)
            }
        }
    }
    
    func loadRecipesListWithUrlNewResults(url: String, offset: Int, completionHandler: @escaping (_ result: Bool, _ error: String?) -> Void) {
    
        finishedRequest = false
        
        self.worker?.getRecipesWithUrlNewResults(urlTeste: url, offset: offset) { (recipes, error) in
            
            if let _recipes = recipes {
                
                self.recipes.append(contentsOf: _recipes.results)
                completionHandler(true, nil)
                self.finishedRequest = true
            }else{
            
                completionHandler(false, error)
                self.finishedRequest = true
            }
        }
    }    
}
