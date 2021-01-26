//
//  MainTabBarController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 05/11/20.
//

import UIKit

class MainTabBarController: UITabBarController, ShoppingListDelegate {

    
    var loginReferrerIndex: Int?
    
    enum TabsIndex: Int {
        case Recipes = 0
        case Favorites = 1
        case ShoppingList = 2
        case Settings = 3
    }
    
    
    func transitionTo(destinationTab: TabsIndex) {
        self.loginReferrerIndex = self.selectedIndex
        self.selectedIndex = destinationTab.rawValue
    }
    
    
    func transitionBackToReferrer() {
        if let index = self.loginReferrerIndex {
            self.selectedIndex = index
        }
        self.loginReferrerIndex = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ShoppingList.shared.subscribe(delegate: self)
        
    }
    
    
    private func getShoppingListTabBarItem() -> UITabBarItem? {
        if let items = self.tabBar.items {
            for item in items {
                if(item.tag == 1000) {
                    return item
                }
            }
        }
        return nil
    }
    
    
    // MARK: ShoppingListDelegate - Methods
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        updateShoppingListBadge()
    }
    
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        updateShoppingListBadge()
    }
    
    func didCheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        updateShoppingListBadge()
    }
    
    func didUncheck(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        updateShoppingListBadge()
    }
    
    
    private func updateShoppingListBadge() {
        guard let item: UITabBarItem = self.getShoppingListTabBarItem() else {
            return
        }
        
        let quantidadeItens = ShoppingList.shared.getDesmarcados().count
        
        if quantidadeItens == 0 {
            item.badgeValue = nil
            item.badgeColor = .none
            return
        }
        
        item.badgeColor = .systemRed
        item.badgeValue = "\(quantidadeItens < 10 ? "\(quantidadeItens)" : "9+")"
    }
}
