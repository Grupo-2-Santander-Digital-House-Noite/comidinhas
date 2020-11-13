//
//  SearchTableViewCell.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 09/11/20.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    
    func findClick()
    
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var findButton: UIButton!
    
    var mealTypes: [String] = [String]()
    
    weak var delegate: SearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
        mealTypes = ["All", "Main Course", "Side Dish", "Dessert", "Apptizer", "Salad", "Bread", "Breakfast", "Soup", "Beverage", "Sauce", "Marinade", "Fingerfood", "Snack", "Drink"]

        ingredientsTextView.delegate = self
        ingredientsTextView.text = "Enter the ingredients separated by comma"
        ingredientsTextView.textColor = UIColor.lightGray
        ingredientsTextView.layer.cornerRadius = 4
        categoryPickerView.layer.cornerRadius = 4
        findButton.layer.cornerRadius = findButton.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func finButtonClick(_ sender: UIButton) {
        delegate?.findClick()
    }
    
}

extension SearchTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}

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
}
