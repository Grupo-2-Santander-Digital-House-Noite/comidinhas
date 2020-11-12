//
//  FavoritesController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation

protocol FavoriteControllerUpdate: AnyObject {
    func didUpdate()
}

class FavoritesController: FavoritesUpdateDelegate {
    
    // MARK: State
    private var favoritos: [Recipe] = []
    
    // MARK: Public properties
    var numberOfRows: Int {
        return self.favoritos.count
    }
    
    weak var delegate: FavoriteControllerUpdate?
    
    // MARK: Public Methods
    init() {
        FavoritosWebService.shared.delegate = self
    }
    
    func load() {
        self.favoritos = RecipesWebService.shared.with(ids: FavoritosWebService.shared.favoriteIds)
    }
    
    func favoriteRecipeAt(index: Int) -> Recipe? {
        if index > -1 && index < self.favoritos.count {
            return self.favoritos[index]
        }
        return nil
    }
    
    func removeFavoriteAt(index: Int) {
        FavoritosWebService.shared.removeFavorite(recipe: self.favoritos[index])
        self.load()
    }
    
    func didUpdateFavorites() {
        self.load()
        self.delegate?.didUpdate()
    }
    // MARK: Internal Behavior
    
    
}
