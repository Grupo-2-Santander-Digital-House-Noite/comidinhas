//
//  SearchVCModel.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 03/02/21.
//

import Foundation
import UIKit

struct SearchVCModel {
    var mealTypes: [String] = ["All", "Main Course", "Side Dish", "Dessert", "Apptizer", "Salad", "Bread", "Breakfast", "Soup", "Beverage", "Sauce", "Marinade", "Fingerfood", "Snack", "Drink"]
    
    func filter(ingredientsTextView: UITextView, recipeNameTextField: UITextField, catPickerView: UIPickerView, timeToBeReadyTextField: UITextField) -> [RecipeFilter] {
        var filters: [RecipeFilter] = []
        if let _filter: RecipeFilter = self.getIngredientsFilter(ingredientsTextView: ingredientsTextView){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTermFilter(recipeNameTextField: recipeNameTextField){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTypeFilter(catPickerView: catPickerView){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTimeFilter(timeToBeReadyTextField: timeToBeReadyTextField) {
            filters.append(_filter)
        }
        return filters
    }
    
    func getIngredientsFilter(ingredientsTextView: UITextView) -> RecipeFilter? {
        
        if ingredientsTextView.hasText{
            if ingredientsTextView.text != "Enter the ingredients separated by comma"
            {
                if let _text = ingredientsTextView.text {
                    let ingredients = _text.split(separator: ",").map{ (ingredient) -> String in
                        return ingredient.trimmingCharacters(in: .whitespaces)
                    }
                    return IngredientsFilter(withIngredients: ingredients)
                }
            }
        }
        return nil
    }
    
    func getTermFilter(recipeNameTextField: UITextField) -> RecipeFilter? {
        if recipeNameTextField.hasText{
            if let _text = recipeNameTextField.text {
                return SimpleTermFilter(withValues: _text.trimmingCharacters(in: .whitespaces))
            }
        }
        return nil
    }
    
    func getTypeFilter(catPickerView: UIPickerView) -> RecipeFilter? {
        let pickerOption:Int = catPickerView.selectedRow(inComponent: 0)
        if(pickerOption == 0)
        {
            return nil
        }
        if MealType.allCases.count > pickerOption,
           let _mealType = MealType.allCases[pickerOption] as? MealType {
            return MealTypeFilter(withType: _mealType)
        }
        return nil
    }
    
    func getTimeFilter(timeToBeReadyTextField: UITextField) -> RecipeFilter? {
        if timeToBeReadyTextField.hasText,
           let time = timeToBeReadyTextField.text {
            return PrepareTimeFilter(withTime: time)
        }
        return nil;
    }
}
