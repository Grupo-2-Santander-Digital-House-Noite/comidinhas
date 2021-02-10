//
//  RecipesWorker.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//
//let apiKey = "apiKey=502b1cdef5214e57b5d699e67328eeea"
//let apiKey = "apiKey=0faf1734746a4e2691700a7a49dc1cef"

import Foundation

class RecipesWorker: GenericWorker {
    
    let recipeURL = "https://api.spoonacular.com/recipes/"
    let apiKey = "apiKey=0faf1734746a4e2691700a7a49dc1cef"
    
    let searchByName = "complexSearch?titleMatch="
    let searchByIngredients = "findByIngredients?"
    let ingredients = "includeIngredients="
    
    
    func fetchRecipeByName(name: String) -> String {
        let urlString = "\(recipeURL)\(searchByName)\(name)&addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true"
        return urlString
    }
    
    func getRecipesWithUrl(urlTeste: String, completion: @escaping completion<RecipeResults?>) {
        let session: URLSession = URLSession.shared
        var teste = ""
        if urlTeste == "https://api.spoonacular.com/recipes/complexSearch?"
        {
            teste = "\(urlTeste)addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        else
        {
            teste = "\(urlTeste)&addRecipeInformation=true&instructionsRequired=true&number=5&\(apiKey)&fillIngredients=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
    
    
    func getRecipesWith(ids: [Int], completion: @escaping ([Recipe]) -> Void, failure: @escaping (Error) -> Void) {

        if ids.count == 0 {
            completion([])
            return
        }

        let idsComVirgulas: String = ids.map { (id) -> String in
            return String(id)
        }.joined(separator: ",")
        let urlString = "https://api.spoonacular.com/recipes/informationBulk?\(apiKey)&ids=\(idsComVirgulas)"

        guard let url = URL(string: urlString) else {
            failure(GenericError.GenericErrorWithMessage(message: "Erro ao montar url"))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }

            if let data = data {
                do {
                    let results = try JSONDecoder().decode(BulkRecipeResults.self, from: data)
                    DispatchQueue.main.async { completion(results) }
                    return
                } catch {
                    DispatchQueue.main.async { failure(error) }
                    return
                }
            }


            DispatchQueue.main.async { failure(GenericError.GenericErrorWithMessage(message: "Não desempacotou o data!")) }
            return
        }
        dataTask.resume()
    }
}
