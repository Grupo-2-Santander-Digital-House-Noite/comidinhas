//
//  FavoritosWebService.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation

class FavoritosWebService {
    
    private var idsFavoritos: [Int] = [644733, 1096055, 782601, 715392, 716437, 715447]
    weak var delegate: FavoritesUpdateDelegate?
    
    var favoriteIds: [Int] {
        return self.idsFavoritos
    }
    
    static var shared: FavoritosWebService = { () -> FavoritosWebService in
        let instance = FavoritosWebService()
        return instance
    }()
    
    private init() {
        
    }
    
    func isFavorite(id: Int) -> Bool {
        return self.idsFavoritos.contains(id)
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
        return self.favoriteIds.contains(recipe.id ?? 0)
    }
    
    func addFavorite(id: Int) {
        if !self.idsFavoritos.contains(id) {
            self.idsFavoritos.append(id)
        }
        self.delegate?.didUpdateFavorites()
    }
    
    func removeFavorite(id: Int) {
        if self.idsFavoritos.contains(id) {
            self.idsFavoritos = self.idsFavoritos.filter({ (_id) -> Bool in
                return _id != id
            })
            self.delegate?.didUpdateFavorites()
        }
    }
    
    func addFavorite(recipe: Recipe?) {
        self.addFavorite(id: recipe?.id ?? 0)
    }
    
    func removeFavorite(recipe: Recipe?) {
        self.removeFavorite(id: recipe?.id ?? 0)
    }
    
}
