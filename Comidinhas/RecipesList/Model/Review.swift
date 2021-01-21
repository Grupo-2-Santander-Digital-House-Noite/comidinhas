//
//  Reviews.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import Foundation
import FirebaseFirestore

class Review {
    
    var reviewId: String {
        get {
            return "\(self.recipeId)_\(self.userId)"
        }
    }
    
    var ratingStars: String {
        get {
            switch self.rating {
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
    
    
    var recipeId: Int
    var date: Date
    var comment: String
    var rating: Int
    var userFullName: String
    var userId: String
    
    init(recipeId: Int, userId: String, date: Date, rating: Int, comment: String, userFullName: String) {
        self.recipeId = recipeId
        self.userId = userId
        self.date = date
        self.rating = rating
        self.comment = comment
        self.userFullName = userFullName
    }
    
    init(firestoreData: [String: Any]) {
        self.recipeId = firestoreData["recipeId"] as? Int ?? 0
        self.userId = firestoreData["userId"] as? String ?? "0"
        if let date = firestoreData["date"] as? Timestamp {
            self.date = date.dateValue()
        } else {
            self.date = Date()
        }
        self.rating = firestoreData["rating"] as? Int ?? 0
        self.comment = firestoreData["comment"] as? String ?? ""
        self.userFullName = firestoreData["userFullName"] as? String ?? ""
    }
    
    func asFirestoreData() -> [String: Any] {
        var data: [String: Any] = [:]
        data["recipeId"] = self.recipeId
        data["userId"] = self.userId
        data["date"] = self.date
        data["rating"] = self.rating
        data["comment"] = self.comment
        data["userFullName"] = self.userFullName
        return data
    }
    
    static func ratingFrom(stars: String) -> Int {
        switch stars {
        case "★☆☆☆☆":
            return 1
        case "★★☆☆☆":
            return 2
        case "★★★☆☆":
            return 3
        case "★★★★☆":
            return 4
        case "★★★★★":
            return 5
        default:
            return 0
        }
    }
}

