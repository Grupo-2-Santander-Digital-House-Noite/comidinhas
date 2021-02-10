//
//  ShoppingList.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 23/10/20.
//

import Foundation
import CoreData
import UIKit


class ShoppingList: ToggleIngredientMarkedDelegate {
    
    public static let ListItemEntityName = "ListItem"
    
    private var delegates: [ShoppingListDelegate]
    private static var instance: ShoppingList?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var list:[ListItem]?
    
    static var shared: ShoppingList {
        guard let _instance = self.instance else {
            self.instance = ShoppingList()
            return self.instance!
        }
        
        return _instance
    }
    
    private init() {
        delegates = []
    }
    
    
    /**
        Transforma o atributo marked (Bool) recebido do CoreData no enum MARCADO ou DESMARCADO
     */
    func dataToState(rawValue:Bool) -> ShoppingListItemStateEnum {
        return rawValue ? .MARCADO : .DESMARCADO
    }
    
    /**
     Transforma o enum MARCADO ou DESMARCADO em atributo marked (Bool) do CoreData
     */
    func stateToData(state: ShoppingListItemStateEnum) -> Bool {
        return state == .MARCADO
    }
    
    /**
        Adiciona um ingrediente a lista
     
        - Parameter ingredient: Ingrediente sendo adicionado.
     */
    func add(ingredient: IngredientEntry) -> Void {
        
        // Verifica se existe.
        if let item = self.getIngredientByName(name: ingredient.name) {
        // Se existe aumenta a quantidade e passa para a comprar
            item.quantity = item.quantity + ingredient.quantity
            item.marked = false
        } else {
        // Se não existe cria um novo.
            let newingredient = ListItem(context: self.context)
            newingredient.name = ingredient.name
            newingredient.measureUnity = ingredient.measureUnity
            newingredient.quantity = ingredient.quantity
            newingredient.marked = false
        }
        
        // Salva CoreData
        do {
            try self.context.save()
        } catch {
            print("Error saving item -> \(error)")
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
        
        // Verifica se o ingrediente existe.
        if let item = self.getIngredientByName(name: ingredient.name) {
            // Se existir apaga o ingrediente.
            self.context.delete(item)
        }
        
        do {
            try self.context.save()
        } catch {
            print("Error: \(error)")
        }
        
        self.delegates.forEach { (delegate) in
            delegate.didRemove(self, ingredient: ingredient)
        }
    }
    
    /**
        Remove todos os ingredientes.
     */
    func clear() {
        // Limpando armazenamento da instancia.
        self.list = []
        // Limpando armazenamento do CoreData.
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ShoppingList.ListItemEntityName)
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("--- Erro ao tentar limpar o coredata ---")
            print(error.localizedDescription)
            print(error)
        }
        
        for delegate in self.delegates {
            delegate.didRemove(self, ingredient: IngredientEntry(named: "All", withAmount: 0, andMeasureUnity: "All"))
        }
    }
    
    /**
        Obtem todas as entradas de ingredientes da lista
        - Returns: Array de ingredientes cadastrados na lista.
     */
    func getAll() -> [IngredientEntry] {
        // CoreData
        do {
            // Pego os ingredientes que estão na CoreData
            let request = ListItem.fetchRequest() as NSFetchRequest<ListItem>
            let sortName = NSSortDescriptor(key: "name", ascending: true)
            let sortMarked = NSSortDescriptor(key: "marked", ascending: true)
            request.sortDescriptors = [sortMarked, sortName]
            self.list = try self.context.fetch(request)
            
            guard let listItems = self.list else { return [] }
            
            var ingredientEntries: [IngredientEntry] = []
            for item in listItems {
                let ingredientEntry: IngredientEntry = IngredientEntry(with: nil)
                ingredientEntry.name = item.name ?? "No name"
                ingredientEntry.quantity = item.quantity
                ingredientEntry.measureUnity = item.measureUnity ?? "Unit"
                ingredientEntry.marked = self.dataToState(rawValue: item.marked)
                ingredientEntries.append(ingredientEntry)
            }
            return ingredientEntries
            
        } catch {
            print("Error fetching the whole list from CoreData -> \(error)")
        }
        return []
    }
    
    func getDesmarcados() -> [IngredientEntry] {
        return self.getAll().filter { (entry) -> Bool in
            return entry.marked == .DESMARCADO
        }
    }
    
    /**
        Obtem um ingrediente da lista pelo nome.
     
        - Parameter name: Nome do ingrediente sendo pesquisado.
        - Returns: Ingrediente se encontrado.
     */
    func getIngredientByName(name: String) -> ListItem? {
        
        let filter: NSPredicate = NSPredicate(format: "name == %@", name)
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ShoppingList.ListItemEntityName)
        request.predicate = filter
        
        do {
            let items = try context.fetch(request) as? [ListItem]
            let item = items?.first
            return item
        } catch {
            return nil
        }
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
        
        if let ingredient = self.getIngredientByName(name: ingredientEntry.name) {
            ingredient.marked = marked == ShoppingListItemStateEnum.MARCADO
            do {
                try self.context.save()
            } catch {
                print("Erro ao salvar")
            }
        }
        
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
