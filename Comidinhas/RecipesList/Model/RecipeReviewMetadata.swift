//
//  RecipeReviewMetadata.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 20/01/21.
//

import Foundation

class RecipeReviewMetadata {
    
    static let CountKey: String = "reviewCount"
    static let SumKey: String = "ratingSum"
    static let ComputedKey: String = "averageRating"
    
    private var _count: Int
    private var _sum: Int
    
    var reviewCount: Int {
        get {
            return _count
        }
    }
    var reviewRatingSum: Int {
        get {
            return _sum
        }
    }
    
    var ratingStars: String {
        get {
            switch self.reviewRatingComputed {
            case 1:
                return "★☆☆☆☆"
            case 2:
                return "★★☆☆☆"
            case 3:
                return "★★★☆☆"
            case 4:
                return "★★★★☆"
            case 5:
                return "★★★★★"
            default:
                return "☆☆☆☆☆"
            }
        }
    }
    
    var reviewRatingComputed: Int {
        get {
            
            if self.reviewCount == 0 {
                return 0
            }
            
            return Int(self.reviewRatingSum / self.reviewCount)
        }
    }
    
    init(reviewCount: Int, reviewRatingSum: Int) {
        self._count = reviewCount
        self._sum = reviewRatingSum
    }
    
    init(firestoreData: [String: Any]?) {
        
        if let firestoreData = firestoreData {
            self._count = firestoreData[RecipeReviewMetadata.CountKey] as? Int ?? 0
            self._sum = firestoreData[RecipeReviewMetadata.SumKey] as? Int ?? 0
        } else {
            self._count = 0
            self._sum = 0
        }
    }
    
    func asFirestoreData() -> [String: Any] {
        var data: [String: Any] = [:]
        data[RecipeReviewMetadata.CountKey] = self._count
        data[RecipeReviewMetadata.SumKey] = self._sum
        data[RecipeReviewMetadata.ComputedKey] = self.reviewRatingComputed
        return data
    }
    
    func addReview(_ review: Review, oldRating: Int? = nil) -> Void {
        if let oldRating = oldRating {
            self._sum = self._sum - oldRating
        } else {
            self._count = self.reviewCount + 1
        }
        self._sum = self.reviewRatingSum + review.rating
    }
}
