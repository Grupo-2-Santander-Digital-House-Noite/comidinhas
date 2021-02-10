//
//  RecipesModel.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 03/02/21.
//

import Foundation

struct RecipeModel {
    
    var url: String = ""
    
    mutating func createUrlString(filter: [RecipeFilter], notFirstCall: Bool) {
        //var url: String = ""
        if filter.count == 0 {
            url = "Utilize a tela de filtro para montar uma url"
            if(notFirstCall){
                url = "https://api.spoonacular.com/recipes/complexSearch?"
            }
        } else {
            RecipesWebService.shared.lastFilter = filter
            url = "https://api.spoonacular.com/recipes/complexSearch"
            var components: [String] = []
            for _filter in filter {
                components.append("\(_filter.name)=\(_filter.value)")
            }
            url = "\(url)?\(components.joined(separator: "&"))"
        }
    }
}

