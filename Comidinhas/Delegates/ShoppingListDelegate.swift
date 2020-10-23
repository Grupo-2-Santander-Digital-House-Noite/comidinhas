//
//  ShoppingListDelegate.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation

protocol ShoppingListDelegate {
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
}

extension ShoppingListDelegate {
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
    
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) -> Void {
        // Torna o método opicional
    }
}
