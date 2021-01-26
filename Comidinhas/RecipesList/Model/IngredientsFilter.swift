//
//  IngredientsFilter.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//

import Foundation

class IngredientsFilter: RecipeFilter {
    
    private let _name: String
    private let _values: String
    
    var name: String{
        return _name
    }
    
    var value: String{
        return _values
    }
    
    init(withIngredients ingredients: [String]) {
        self._name = "includeIngredients"
        self._values = ingredients.joined(separator: ",")
    }
}
