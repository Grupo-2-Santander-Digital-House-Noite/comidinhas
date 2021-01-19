//
//  RecipesWorker.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//

import Foundation

class RecipesWorker: GenericWorker {
    
    let recipeURL = "https://api.spoonacular.com/recipes/"
    let apiKey = "apiKey=0faf1734746a4e2691700a7a49dc1cef"
    
    let searchByName = "complexSearch?titleMatch="
    let searchByIngredients = "findByIngredients?"
    let ingredients = "includeIngredients="
    
    //var delegate: RecipeManagerDelegate?
    
    func fetchRecipeByName(name: String) -> String {
        let urlString = "\(recipeURL)\(searchByName)\(name)&addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true"
        return urlString
    }
    
    func getRecipesWithUrl(urlTeste: String, completion: @escaping completion<RecipeResults?>) {
        
        let session: URLSession = URLSession.shared
        
        var teste = ""
        
        if urlTeste == "https://api.spoonacular.com/recipes/complexSearch?"
        {
            teste = "\(urlTeste)addRecipeInformation=true&instructionsRequired=true&number=20&\(apiKey)&fillIngredients=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        else
        {
            teste = "\(urlTeste)&addRecipeInformation=true&instructionsRequired=true&number=20&\(apiKey)&fillIngredients=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        let url: URL? = URL(string: teste)
        
            if let _url = url {
            
            let task: URLSessionTask = session.dataTask(with: _url) { (data, response, error) in
        
                do {
                    let cardList = try JSONDecoder().decode(RecipeResults.self, from: data ?? Data())
                    
                    completion(cardList, nil)
                    
                }catch {
                    completion(nil,"deu ruim no catch")
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func getRecipesWithUrlNewResults(urlTeste: String, offset: Int, completion: @escaping completion<RecipeResults?>) {
        
        let session: URLSession = URLSession.shared
        
        var teste = ""
        
        if urlTeste == "https://api.spoonacular.com/recipes/complexSearch?"
        {
            teste = "\(urlTeste)addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true&offset=\(offset)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        else
        {
            teste = "\(urlTeste)&addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true&offset=\(offset)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        let url: URL? = URL(string: teste)
        
            if let _url = url {
            
            let task: URLSessionTask = session.dataTask(with: _url) { (data, response, error) in
        
                do {
                    let cardList = try JSONDecoder().decode(RecipeResults.self, from: data ?? Data())
                    
                    completion(cardList, nil)
                    
                }catch {
                    completion(nil,"deu ruim no catch")
                    print(error)
                }
            }
            task.resume()
        }
    }
}
