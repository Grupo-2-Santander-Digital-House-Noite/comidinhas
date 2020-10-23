//
//  ShoppingList.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

class ShoppingList {
    
    private var shoppingList: [String: IngredientEntry]
    private var delegates: [ShoppingListDelegate]
    
    static var shared: ShoppingList {
        let shoppingList = ShoppingList()
        return shoppingList;
    }
    
    private init() {
        shoppingList = [:];
        delegates = []
    }
    
    /**
        Adiciona um ingrediente a lista
     
        - Parameter ingredient: Ingrediente sendo adicionado.
     */
    func add(ingredient: IngredientEntry) -> Void {
        if(self.shoppingList.keys.contains(ingredient.name)) {
            self.shoppingList[ingredient.name]?.quantity = (self.shoppingList[ingredient.name]?.quantity ?? 0) + ingredient.quantity
        } else {
            self.shoppingList[ingredient.name] = ingredient
        }
        
        // Notifica os delegates da adição.
        self.delegates.forEach { (delegate) in
            delegate.didAdd(self, ingredient: ingredient)
        }
        
    }
    
    /**
        Remove um ingrediente da lista
     
        - Parameter ingredient: Ingrediente a ser removido, usa o nome para determinar equidade.
     */
    func remove(ingredient: IngredientEntry) -> Void {
        if(!self.shoppingList.keys.contains(ingredient.name)) {
            return
        }
        
        self.shoppingList.removeValue(forKey: ingredient.name)
        
        self.delegates.forEach { (delegate) in
            delegate.didAddItem(self, ingredient: ingredient)
        }
    }
    
    /**
        Obtem todas as entradas de ingredientes da lista
     
        - Returns: Array de ingredientes cadastrados na lista.
     */
    func getAll() -> [IngredientEntry] {
        return self.shoppingList.values.map { (ingredientEntry) -> IngredientEntry in
            return ingredientEntry
        }
    }
    
    /**
        Obtem um ingrediente da lista pelo nome.
     
        - Parameter name: Nome do ingrediente sendo pesquisado.
        - Returns: Ingrediente se encontrado.
     */
    func getIngredientByName(name: String) -> IngredientEntry? {
        if(!self.shoppingList.keys.contains(name)) {
            return nil
        }
        
        return self.shoppingList[name]
    }
}
