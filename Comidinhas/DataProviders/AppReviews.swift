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
    private var auth: Auth
    private var db: Firestore
    
    // MARK: - Singleton Methods
    static var shared: AppReviews {
        let instance = AppReviews()
        return instance
    }
    
    private init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    // MARK: - Persist Logic
    func saveReview(review: Review,
                    completion: @escaping (() -> Void),
                    failure: @escaping ((Error) -> Void)) {
        
        if AppUserManager.shared.hasLoggedUser() {
            
            self.db.runTransaction { (transaction, errorPointer) -> Any? in
                
                let documentReviewRef: DocumentReference = self.db.collection("reviews").document(review.reviewId)
                
                // Verifica se review já existe.
                var existe: Bool = false
                var notaAntiga: Int? = nil
                do {
                    let reviewDocument: DocumentSnapshot
                    try reviewDocument = transaction.getDocument(documentReviewRef)
                    if let data = reviewDocument.data() {
                        let review = Review(firestoreData: data)
                        notaAntiga = review.rating
                        existe = true
                    }
                } catch {
                    existe = false
                }
                
                documentReviewRef.setData(review.asFirestoreData())
                
                let documentMetaRef: DocumentReference = self.db.collection("recipesReviewsMetadata").document("\(review.recipeId)")
                documentMetaRef.getDocument { (documentSnapshot, error) in
                    if let documentSnapshot = documentSnapshot {
                        let data: [String: Any] = documentSnapshot.data() ?? [:]
                        let recipeReviewMeta = RecipeReviewMetadata(firestoreData: data)
                        recipeReviewMeta.addReview(review, oldRating: notaAntiga)
                        documentMetaRef.setData(recipeReviewMeta.asFirestoreData())
                    }
                }
                
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
    
    // MARK: - Read Logic
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
            
            var reviews: Reviews = []
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    reviews.append(Review(firestoreData: document.data()))
                }
            }
            
            self.loadRecipeFromRecipeAndUser(id: id, reviews: reviews) { (reviews) in
                completion(reviews)
            } failure: { (error) in
                failure(error)
            }
        }
    }
    
    func loadRecipeFromRecipeAndUser(id: Int, reviews: Reviews, completion: @escaping (Reviews) -> Void, failure: @escaping (Error) -> Void) {
        
        // Verifica se há um usuário logado, caso não exista
        // Retorna apenas as que já estão carregadas até agora.
        guard let currentUser = self.auth.currentUser else {
            completion(reviews)
            return;
        }
        var query = self.db.collection("reviews")
            .whereField("recipeId", isEqualTo: id)
            .whereField("userId", isEqualTo: currentUser.uid)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                failure(error)
                return;
            }
            
            var reviewsAtualizadas: Reviews = reviews.filter { (review) -> Bool in
                return review.userId != currentUser.uid
            }
            // Se tiver uma review adiciona as que já existem.
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let review = Review.init(firestoreData: document.data())
                    reviewsAtualizadas.append(review)
                }
            }
            completion(reviewsAtualizadas)
        }
    }
    
    
    func loadRecipeReviewMetaDataWithRecipe(id: Int, completion: @escaping ((RecipeReviewMetadata) -> Void), failure: @escaping ((Error) -> Void)) {
        
        self.db.collection("recipesReviewsMetadata")
            .document("\(id)").getDocument { (documentSnapshot, error) in
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


