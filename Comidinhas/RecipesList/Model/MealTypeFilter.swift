//
//  MealTypeFilter.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//

import Foundation

class MealTypeFilter: RecipeFilter {
    
    private let _name: String
    private let _type: MealType
    
    var name: String{
        return _name
    }
    
    var value: String{
        return _type.rawValue
    }
    
    init(withType type: MealType) {
        self._name = "type"
        self._type = type
    }
}
