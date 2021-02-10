//
//  ShoppingListItemTableViewCell.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 24/10/20.
//

import UIKit

class ShoppingListItemTableViewCell: UITableViewCell {

    var imageNameForState: [ShoppingListItemStateEnum: String] = [
        .MARCADO: "checkmark.square.fill",
        .DESMARCADO : "square"
    ]
    var ingredientEntry: IngredientEntry?
    
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(ingredient: IngredientEntry) {
        ingredient.subscribe(toggleDelegate: self)
        self.ingredientEntry = ingredient
        self.descriptionLabel.text = "\(String.init(format: "%.2f", ingredient.quantity)) \(ingredient.measureUnity) - \(ingredient.name)"
        updateCell()
    }
    
    func toggle() -> Void {
        self.ingredientEntry?.toggle()
    }
    
    func updateCell() -> Void {
        
        let status: ShoppingListItemStateEnum = self.ingredientEntry?.marked ?? .DESMARCADO
        
        if let image: UIImage = UIImage(systemName: imageNameForState[ status ] ?? "") as? UIImage {
            self.indicatorImage.image = image
        }
        
        let color: UIColor = status == .DESMARCADO ? .black : .systemGray
        self.descriptionLabel.textColor = color
        self.indicatorImage.tintColor = color
    }
}


// MARK: - extension ToggleIngredientesMarkedDelegate
extension ShoppingListItemTableViewCell : ToggleIngredientMarkedDelegate {
    func toggled(ingredientEntry: IngredientEntry, marked: ShoppingListItemStateEnum) {
        self.ingredientEntry = ingredientEntry
        self.updateCell()
    }
}
