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

enum FavoriteState {
    case empty
    case loading
    case error
    case loaded
}

class FavoritesController: FavoritesUpdateDelegate {
    
    // MARK: State
    private var favoritos: [Recipe] = []
    private var _state: FavoriteState = .empty
    
    // MARK: Public properties
    var numberOfRows: Int {
        switch self._state {
        case .loading:
            return 1
        case .empty:
            return 1
        case .error:
            return 1
        case .loaded:
            return self.favoritos.count
        }
    }
    
    var state: FavoriteState {
        return _state
    }
    
    weak var delegate: FavoriteControllerUpdate?
    
    // MARK: Initializer/Deinitializer
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesController.didUpdateFavorites), name: FavoritosWebService.UPDATE_NOTIFICATION_NAME, object: nil)
        self._state = .empty
        loadRecipesIfLoggedUser()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadRecipesIfLoggedUser() {
        if !AppUserManager.shared.hasLoggedUser() {
            print("Usuário não logado!")
            return
        }
        
        self._state = .loading
        FavoritosWebService.shared.reloadFavoritesIdsFromLoggedUser()

    }
    
    // MARK: Public Methods
    func load() {
        
        self._state = .loading
        RecipesWebService.shared.with(ids: FavoritosWebService.shared.favoriteIds, completion: { (recipes) in
            self.favoritos = recipes
            self._state = recipes.count > 0 ? .loaded : .empty
            self.delegate?.didUpdate()
        }, failure: { (error) in
            self._state = .error
            print(error.localizedDescription)
        })
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
    
    @objc func didUpdateFavorites() {
        self.load()
        self.delegate?.didUpdate()
    }
}
