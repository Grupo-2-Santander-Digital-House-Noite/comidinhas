//
//  AppFavoritos.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 15/12/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase


class AppFavoritos {
    private var currentLoggedUser: User?
    private var auth: Auth
    private var db: Firestore
    
    // MARK: Singleton Methods
    static var shared: AppFavoritos {
        let instance = AppFavoritos()
        return instance
    }
    
    private init() {
        self.currentLoggedUser = nil
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    
    func AddFavoriteRecipeToFirestore(RecipeID: Int?, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        // Faz um alias para o failure
        let reportError = {(error:Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        
        if AppUserManager.shared.hasLoggedUser() {
            self.db.collection("users").document(self.auth.currentUser?.uid ?? "").updateData(["RecipesIds" : FieldValue.arrayUnion([RecipeID ?? 0])])
        }
        if let _completion = completion {
            _completion()
        }
    }
    
    
    func RemoveFavoriteRecipeFromFirestore(RecipeID:Int?, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        // Faz um alias para o failure
        let reportError = {(error:Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        
        if AppUserManager.shared.hasLoggedUser() {
            self.db.collection("users").document(self.auth.currentUser?.uid ?? "").updateData(["RecipesIds":FieldValue.arrayRemove([RecipeID ?? 0])])
        }
        if let _completion = completion {
            _completion()
        }
    }
    
    func getRecipesIdsFromUser(withUid uid: String, completion: @escaping ([Int]) -> Void, failure: @escaping (Error) -> Void) {
        
        self.db.collection("users").document(uid).getDocument { (document, error) in
            
            if let error = error {
                failure(error)
                return
            }
            
            if let document = document,
               let ids: [Int] = document.get("RecipesIds") as? [Int] {
                completion(ids)
                return
            }
            failure(GenericError.GenericErrorWithMessage(message: "Não desempacotou o documento!"))
        }
    }
}
