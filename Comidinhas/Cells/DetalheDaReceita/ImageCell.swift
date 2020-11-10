//
//  ImageCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 27/10/20.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
