//
//  FavoritesCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 22/10/20.
//

import UIKit

class FavoritesCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(favorites:Favorites) {
        self.recipeImage.image = UIImage(named: favorites.imagemReceita)
        self.nameLabel.text = favorites.nomeReceita
    }
    
}
