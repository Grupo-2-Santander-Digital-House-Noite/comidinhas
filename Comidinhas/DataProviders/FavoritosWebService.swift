//
//  FavoritosWebService.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


public class FavoritosWebService {
    
    private var db = Firestore.firestore()
    private var user = Auth.auth()
    
    static let UPDATE_NOTIFICATION_NAME: NSNotification.Name = NSNotification.Name(rawValue: "FavoritosWebService.Updated")
    
    private var idsFavoritos: [Int] = []
    
    var favoriteIds: [Int] {
        return self.idsFavoritos
    }
    
    static var shared: FavoritosWebService = { () -> FavoritosWebService in
        let instance = FavoritosWebService()
        return instance
    }()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadFavorites(notification:)), name: AppUserManager.userLoggedInNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unloadFavorites), name: AppUserManager.userLoggedOutNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadFavoritesIdsFromLoggedUser() {
        if let user = AppUserManager.shared.loggedUser {
            AppFavoritos.shared.getRecipesIdsFromUser(withUid: user.uid ?? "") { (ids) in
                self.idsFavoritos = ids
            } failure: { (error) in
                print("Não conseguiu atualizar")
            }
        }
    }
    
    @objc func loadFavorites(notification: Notification) {
        // Carrega os favoritos.
        if let uid: String = notification.object as? String {
            print("Usuário \(uid) logado!")
            AppFavoritos.shared.getRecipesIdsFromUser(withUid: uid) { (ids) in
                self.idsFavoritos = ids
                self.notifyObservers()
            } failure: { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func unloadFavorites() {
        // Limpa os favoritos.
        print("Usuário deslogou!")
        self.idsFavoritos.removeAll()
        self.notifyObservers()
    }
    
    func isFavorite(id: Int) -> Bool {
        return self.idsFavoritos.contains(id)
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
        return self.favoriteIds.contains(recipe.id ?? 0)
    }
    
    func addFavorite(id: Int) {
        AppFavoritos.shared.AddFavoriteRecipeToFirestore(RecipeID: id) {
            if !self.idsFavoritos.contains(id) {
                self.idsFavoritos.append(id)
            }
            self.notifyObservers()
        } failure: { (error) in
            print(error.localizedDescription)
        }
    }
    
    func removeFavorite(id: Int) {
        if self.idsFavoritos.contains(id) {
            
            AppFavoritos.shared.RemoveFavoriteRecipeFromFirestore(RecipeID: id) {
                if let index = self.idsFavoritos.firstIndex(of: id) {
                    self.idsFavoritos.remove(at: index)
                }
                self.notifyObservers()
            } failure: { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func addFavorite(recipe: Recipe?) {
        self.addFavorite(id: recipe?.id ?? 0)
    }
    
    func removeFavorite(recipe: Recipe?) {
        self.removeFavorite(id: recipe?.id ?? 0)
    }
    
    
    //MARK: Notification Related Stuff
    func notifyObservers() {
        NotificationCenter.default.post(name: FavoritosWebService.UPDATE_NOTIFICATION_NAME, object: nil)
    }
}
