//
//  SearchTableViewCell.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 09/11/20.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    
    func findClick(filter: [RecipeFilter])
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var timeToBeReadyTextField: UITextField!
//    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var findButton: UIButton!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    private var catPickerView: UIPickerView!
    
    var mealTypes: [String] = [String]()
    
    weak var delegate: SearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configPickerView()
        self.catPickerView.delegate = self
        self.catPickerView.dataSource = self
        
//        self.categoryPickerView.delegate = self
//        self.categoryPickerView.dataSource = self
        
        mealTypes = ["All", "Main Course", "Side Dish", "Dessert", "Apptizer", "Salad", "Bread", "Breakfast", "Soup", "Beverage", "Sauce", "Marinade", "Fingerfood", "Snack", "Drink"]

        ingredientsTextView.delegate = self
        ingredientsTextView.text = "Enter the ingredients separated by comma"
        ingredientsTextView.textColor = UIColor.lightGray
        ingredientsTextView.layer.cornerRadius = 5
//        categoryPickerView.layer.cornerRadius = 4
        findButton.layer.cornerRadius = 5
        // Initialization code
    }

    
    // MARK: configPickerView
    private func configPickerView() {
        self.catPickerView = UIPickerView()
        self.categoryTextField.inputView = self.catPickerView

        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(okClick))
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.categoryTextField.inputAccessoryView = toolbar
    }

    @objc private func cancelClick() {
        self.categoryTextField.text = ""
        self.categoryTextField.resignFirstResponder()
    }

    @objc private func okClick() {
//        self.categoryTextField.text = catPickerView[row]
        self.categoryTextField.resignFirstResponder()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func finButtonClick(_ sender: UIButton) {
//        delegate?.findClick()
//    }
    
    @IBAction func finButtonClick(_ sender: UIButton) {
        var filters: [RecipeFilter] = []
        if let _filter: RecipeFilter = self.getIngredientsFilter(){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTermFilter(){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTypeFilter(){
            filters.append(_filter)
        }
        
        if let _filter: RecipeFilter = self.getTimeFilter() {
            filters.append(_filter)
        }
        delegate?.findClick(filter : filters)
    }
    
    func getTimeFilter() -> RecipeFilter? {
        if self.timeToBeReadyTextField.hasText,
           let time = self.timeToBeReadyTextField.text {
            return PrepareTimeFilter(withTime: time)
        }
        return nil;
    }
    
    func getIngredientsFilter() -> RecipeFilter? {
        
        if self.ingredientsTextView.hasText{
            if ingredientsTextView.text != "Enter the ingredients separated by comma"
            {
                if let _text = self.ingredientsTextView.text {
                    let ingredients = _text.split(separator: ",").map{ (ingredient) -> String in
                        return ingredient.trimmingCharacters(in: .whitespaces)
                    }
                    return IngredientsFilter(withIngredients: ingredients)
                }
            }
        }
        return nil
    }
    
    func getTermFilter() -> RecipeFilter? {
        if self.recipeNameTextField.hasText{
            if let _text = self.recipeNameTextField.text {
                return SimpleTermFilter(withValues: _text.trimmingCharacters(in: .whitespaces))
            }
        }
        return nil
    }
    
    func getTypeFilter() -> RecipeFilter? {
        let pickerOption:Int = self.catPickerView.selectedRow(inComponent: 0)
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
    
}

// MARK: extension TextView
extension SearchTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter the ingredients separated by comma"
            textView.textColor = UIColor.lightGray
        }
    }
}

// MARK: extension PickerView
extension SearchTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = mealTypes[row]
    }
}
