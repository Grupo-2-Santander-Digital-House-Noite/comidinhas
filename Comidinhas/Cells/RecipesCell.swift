//
//  RecipesCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipesCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    
    

    override func awakeFromNib() {        super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
     
     
     func setup(receita:Recipe) {
         self.recipeImage.image = UIImage(named: receita.image ?? "")
         self.nameLabel.text = receita.name
         self.timeLabel.text = receita.time
         self.categoryLabel.text = receita.category
         self.servingsLabel.text = receita.servings
     }
     
 }
