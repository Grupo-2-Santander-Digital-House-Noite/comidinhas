//
//  FavoritosWebService.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 12/11/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class FavoritosWebService {
    
    private var db = Firestore.firestore()
    private var user = Auth.auth()
    
    static let UPDATE_NOTIFICATION_NAME: NSNotification.Name = NSNotification.Name(rawValue: "FavoritosWebService.Updated")
    
    private var idsFavoritos: [Int] = [644733, 1096055, 782601, 715392, 716437, 715447]
    
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
        notifyObservers()
        AppFavoritos.shared.AddFavoriteRecipeToFirestore(RecipeID: id) {
            self.idsFavoritos.append(id)
        } failure: { (error) in
            print(error.localizedDescription)
        }
    }
    
    func removeFavorite(id: Int) {
        if self.idsFavoritos.contains(id) {
            self.idsFavoritos = self.idsFavoritos.filter({ (_id) -> Bool in
                return _id != id
            })
            notifyObservers()
            AppFavoritos.shared.RemoveFavoriteRecipeFromFirestore(RecipeID: id) {
                if let index = self.idsFavoritos.firstIndex(of: id) {
                    self.idsFavoritos.remove(at: index)
                }
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
