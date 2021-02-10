//
//  MealType.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 10/12/20.
//

import Foundation

enum MealType: String, CaseIterable {
    
    case all = ""
    case mainCourse = "main course"
    case sideDish = "side Dish"
    case dessert = "dessert"
    case appetizer = "appetizer"
    case salad = "salad"
    case bread = "bread"
    case breakfast = "breakfast"
    case soup = "soup"
    case beverage = "beverage"
    case sauce = "sauce"
    case marinade = "marinade"
    case fingerfood = "fingerfood"
    case snack = "snack"
    case drink = "drink"
    
    static func with(text: String) -> MealType? {
        for mealType in MealType.allCases {
            if text == mealType.rawValue{
                return mealType
            }
        }
        return nil
    }
}
