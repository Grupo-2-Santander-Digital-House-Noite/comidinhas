//
//  SimpleTermFilter.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//

import Foundation

class SimpleTermFilter: RecipeFilter {
    
    private let _name: String
    private let _value: String
    
    var name: String{
        return _name
    }
    
    var value: String{
        return _value
    }
    
    init(withValues values: String) {
        self._name = "titleMatch"
        self._value = values
    }
}
