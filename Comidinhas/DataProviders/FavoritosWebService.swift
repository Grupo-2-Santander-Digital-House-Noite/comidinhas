//
//  FavoritosWebService.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation

class FavoritosWebService {
    
    private var idsFavoritos: [Int] = [644733, 661886, 715392, 716437, 715447]
    
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
    
}
