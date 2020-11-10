//
//  ShoppingList.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

class ShoppingList: ToggleIngredientMarkedDelegate {
    
    private var shoppingList: [String: IngredientEntry]
    private var delegates: [ShoppingListDelegate]
    private static var instance: ShoppingList?
    
    static var shared: ShoppingList {
        guard let _instance = self.instance else {
            self.instance = ShoppingList()
            return self.instance!
        }
        
        return _instance
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
            ingredient.subscribe(toggleDelegate: self)
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
            delegate.didAdd(self, ingredient: ingredient)
        }
    }
    
    /**
        Remove todos os ingredientes.
     */
    func clear() {
        self.shoppingList = [:]
        for delegate in self.delegates {
            delegate.didRemove(self, ingredient: IngredientEntry(named: "All", withAmount: 0, andMeasureUnity: "All"))
        }
    }
    
    /**
        Obtem todas as entradas de ingredientes da lista
        - Returns: Array de ingredientes cadastrados na lista.
     */
    func getAll() -> [IngredientEntry] {
        return self.shoppingList.values.map { (ingredientEntry) -> IngredientEntry in
            return ingredientEntry
        }.sorted { (ingredientA, ingredientB) -> Bool in
            ingredientA.name < ingredientB.name
        }
    }
    
    /**
        Obtem todos os ingredientes ainda marcados como comprados.
        - Returns: Array de ingredientes marcados
     */
    func getMarcados() -> [IngredientEntry] {
        return self.shoppingList.values.filter { (ingredient) -> Bool in
            return ingredient.marked == ShoppingListItemStateEnum.MARCADO
        }.sorted { (ingredientA, ingredientB) -> Bool in
            ingredientA.name < ingredientB.name
        }
    }
    
    /**
        Obtem todos os ingredientes ainda não marcados como comprados.
        - Returns: Array de ingredientes desmarcados.
     */
    func getDesmarcados() -> [IngredientEntry] {
        return self.shoppingList.values.filter { (ingredient) -> Bool in
            return ingredient.marked == ShoppingListItemStateEnum.DESMARCADO
        }.sorted { (ingredientA, ingredientB) -> Bool in
            ingredientA.name < ingredientB.name
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
    
    func subscribe(delegate: ShoppingListDelegate) -> Void {
        self.delegates.append(delegate)
    }
    
    func unsubscribe(delegate: ShoppingListDelegate) -> Void {
        if let index = self.delegates.firstIndex(where: {$0 === delegate}) {
            self.delegates.remove(at: index)
        }
    }
    
    // MARK: ToggleIngredientMarkedDelegate Methods
    func toggled(ingredientEntry: IngredientEntry, marked: ShoppingListItemStateEnum) {
        if marked == .DESMARCADO {
            for delegate in self.delegates {
                delegate.didUncheck(self, ingredient: ingredientEntry)
            }
        } else {
            for delegate in self.delegates {
                delegate.didCheck(self, ingredient: ingredientEntry)
            }
        }
    }
}
