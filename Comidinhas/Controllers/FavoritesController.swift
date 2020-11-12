//
//  FavoritesController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation

class FavoritesController {
    
    // MARK: State
    private var favoritos: [Recipe] = []
    
    // MARK: Public properties
    var numberOfRows: Int {
        return self.favoritos.count
    }
    
    // MARK: Public Methods
    init() {
        
    }
    
    func load() {
        self.favoritos = RecipesWebService.shared.with(ids: FavoritosWebService.shared.favoriteIds)
    }
    
    func favoriteRecipeAt(index: Int) -> Recipe? {
        if index > 0 && index < self.favoritos.count {
            return self.favoritos[index]
        }
        return nil
    }
    
    // MARK: Internal Behavior
    
    
}
