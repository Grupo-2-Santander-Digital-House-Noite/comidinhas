//
//  AppAvaliacoes.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 13/01/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase


class AppReviews {
    private var currentLoggedUser: User?
    private var auth: Auth
    private var db: Firestore
    
    // MARK: Singleton Methods
    static var shared: AppReviews {
        let instance = AppReviews()
        return instance
    }
    
    private init() {
        self.currentLoggedUser = nil
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    
    func AddReviewToFirestore(recipeID: String, review:String, date:String, rating:String, user:String, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        if AppUserManager.shared.hasLoggedUser() {
            self.db.collection("review").document(recipeID).collection("review").document(AppUserManager.shared.loggedUser?.uid ?? "").setData(["user":user, "star": rating, "date": date, "review":review])
            
            self.db.collection("star").document(recipeID).setData([user : rating], merge: true)
        }
        if let _completion = completion {
            _completion()
        }
    }
    
    
    func loadTableViewWithFirestoreData(recipeID:String, completion:(() -> Void)?) {
        Firestore.firestore().collection("review").document(recipeID).collection("review").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let user = data["user"] as? String ?? "No name"
                    let star = data["star"] as? String ?? "No star"
                    let date = data["date"] as? String ?? "No date"
                    let review = data["review"] as? String ?? "No review"
                    
                    var newReview = Reviews(usuario: user, estrelas: star, data: date, comentario: review)
                    arrayReviews.append(newReview)
                    arrayStar.append(star)
                }
            }
        }
    }
}


