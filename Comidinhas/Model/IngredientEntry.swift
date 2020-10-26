//
//  IngredientEntry.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

protocol ToggleIngredientMarkedDelegate: AnyObject {
    func toggled()
}

class IngredientEntry {
    
    /** Nome do Ingrediente **/
    var name: String
    /** Quantidade do Ingrediente **/
    var quantity: Double
    /** Unidade de medida **/
    var measureUnity: String
    
    init(named name: String, withAmount quantity: Double, andMeasureUnity measureUnity: String) {
        self.name = name
        self.quantity = quantity
        self.measureUnity = measureUnity
    }
    
}
