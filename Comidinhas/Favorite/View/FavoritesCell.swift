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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setup(favorites:Favorites) {
        self.recipeImage.image = UIImage(named: favorites.imagemReceita)
        self.nameLabel.text = favorites.nomeReceita
    }
    
    
    func setup(recipe: Recipe?) {
        if let url = URL(string: recipe?.image ?? ""){
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data,
                    error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self!.recipeImage.image = image
                }
            }.resume()
        }
        self.nameLabel.text = recipe?.name ?? "N/A"
    }
}
