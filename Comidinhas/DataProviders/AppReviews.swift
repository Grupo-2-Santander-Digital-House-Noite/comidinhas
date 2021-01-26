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
    
    
    // Salva avaliação do Firestore
    func saveReview(review: Review,
                    completion: @escaping (() -> Void),
                    failure: @escaping ((Error) -> Void)) {
        
        if AppUserManager.shared.hasLoggedUser() {
            
            self.db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let documentMetaRef: DocumentReference = self.db.collection("recipesReviewsMetadata").document("\(review.recipeId)")
                documentMetaRef.getDocument { (documentSnapshot, error) in
                    if let documentSnapshot = documentSnapshot {
                        let data: [String: Any] = documentSnapshot.data() ?? [:]
                        let recipeReviewMeta = RecipeReviewMetadata(firestoreData: data)
                        recipeReviewMeta.addReview(review)
                        documentMetaRef.setData(recipeReviewMeta.asFirestoreData())
                    }
                }
                
                let documentReviewRef: DocumentReference = self.db.collection("reviews").document(review.reviewId)
                documentReviewRef.setData(review.asFirestoreData())
                
                return nil
                
            } completion: { (object, error) in
                
                if let error = error {
                    failure(error)
                    return
                }
                
                completion();
                return
            }

        } else {
            failure(GenericError.GenericErrorWithMessage(message: "Could not save! User isn't logged in."))
        }
    }
    
    
    // Carrega avaliações
    func loadReviewsForRecipeWith(id: Int, reviewsToLoad: Int?, completion: @escaping ((Reviews) -> Void), failure: @escaping ((Error) -> Void)) {
        var query: Query = self.db.collection("reviews").whereField("recipeId", in: [id]).order(by: "date", descending: true)
            
        if let reviewsToLoad = reviewsToLoad {
            query = query.limit(to: reviewsToLoad)
        }
        
        query.getDocuments { (snapshot, error) in
            
            if let error = error {
                failure(error)
                return
            }
                
            if let snapshot = snapshot {
                var reviews: Reviews = []
                for document in snapshot.documents {
                    reviews.append(Review(firestoreData: document.data()))
                }
                completion(reviews)
            }
        }
    }
    
    
    // Carrega os metadados da receita (dados sobre a média)
    func loadRecipeReviewMetaDataWithRecipe(id: Int, completion: @escaping ((RecipeReviewMetadata) -> Void), failure: @escaping ((Error) -> Void)) {
        
        self.db.collection("recipesReviewsMetadata").document("\(id)").getDocument { (documentSnapshot, error) in
            if let error = error {
                failure(error)
                return
            }
                
            if let data = documentSnapshot?.data() {
                let metadata = RecipeReviewMetadata(firestoreData: data)
                completion(metadata)
                return
            }
            failure(GenericError.GenericErrorWithMessage(message: "Could not load the recipes metadata!"))
        }
    }
}


