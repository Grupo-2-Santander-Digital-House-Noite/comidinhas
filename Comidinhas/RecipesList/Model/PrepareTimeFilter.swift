//
//  PrepareTimeFilter.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 14/12/20.
//

import Foundation

class PrepareTimeFilter: RecipeFilter {
    
    // MARK: - Internal State
    private var _value: String
    
    // MARK: - Recipe Filter Properties
    var name : String {
        return "maxReadyTime"
    }
    var value : String {
        return self._value
    }
    
    // MARK: - Métodos
    init(withTime time: String) {
        self._value = time
    }
}
