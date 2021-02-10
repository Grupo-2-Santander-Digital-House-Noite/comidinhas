//
//  ShoppingListDelegate.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

protocol ShoppingListDelegate: AnyObject {
    /**
        Disparado quando um item é adicionado a lista de compras
     
        - Parameter shoppingList: Lista de compras afetada.
        - Parameter ingredient: Ingrediente adicionado.
     */
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void
    
    /**
        Disparado quando um item é removido da lista de compras.
     
        - Parameter shoppingList: Lista de compras afetada.
        - Parameter ingredient: Ingrediente removido
     */
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void
    
    /**
        Disparado quando um item é marcado.
     
        - Parameter shoppingList: Lista de compras afetada.
        - Parameter ingredient: Ingrediente marcado
     */
    func didCheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void
    
    
    /**
        Disparado quando um item é desmarcado.
     
        - Parameter shoppingList: Lista de compras afetada.
        - Parameter ingredient: Ingrediente desmarcado
     */
    func didUncheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void
}


// MARK: - extension ShoppingListDelegate
extension ShoppingListDelegate {
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
    
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
    
    func didCheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
    
    func didUncheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
}
