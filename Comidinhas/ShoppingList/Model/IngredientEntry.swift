//
//  IngredientEntry.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

protocol ToggleIngredientMarkedDelegate: AnyObject {
    func toggled(ingredientEntry: IngredientEntry, marked: ShoppingListItemStateEnum)
}


class IngredientEntry {
    
    /** Nome do Ingrediente **/
    var name: String
    /** Quantidade do Ingrediente **/
    var quantity: Double
    /** Unidade de medida **/
    var measureUnity: String
    /** Se o ingrediente foi marcado */
    var marked: ShoppingListItemStateEnum
    
    private var delegates: [ToggleIngredientMarkedDelegate] = []
    
    init(named name: String, withAmount quantity: Double, andMeasureUnity measureUnity: String, marked: ShoppingListItemStateEnum = .DESMARCADO) {
        self.name = name
        self.quantity = quantity
        self.measureUnity = measureUnity
        self.marked = marked
        self.addShoppingListDelegate()
    }
    
    init(with ingredient: Ingredients?) {
        self.name = ingredient?.ingrediente ?? "Love"
        self.quantity = ingredient?.quantidade ?? 1
        self.measureUnity = ingredient?.unidade ?? "Unit"
        self.marked = .DESMARCADO
        self.addShoppingListDelegate()
    }
    
    func addShoppingListDelegate() {
        self.delegates.append(ShoppingList.shared)
    }
    
    deinit {
        self.delegates = []
    }
    
    func toggle() {
        self.marked = self.marked.toggle()
        self.delegates.forEach({ (delegate) in
            delegate.toggled(ingredientEntry: self, marked: self.marked)
        })
    }
    
    func subscribe(toggleDelegate: ToggleIngredientMarkedDelegate) {
        self.delegates.append(toggleDelegate)
    }
    
    func unsubscribe(toggleDelegate: ToggleIngredientMarkedDelegate) {
        self.delegates.removeAll { (delegate) -> Bool in
            delegate === toggleDelegate
        }
    }
}
