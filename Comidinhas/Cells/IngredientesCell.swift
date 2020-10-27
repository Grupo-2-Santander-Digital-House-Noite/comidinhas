//
//  IngredientesCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 26/10/20.
//

import UIKit

class IngredientesCell: UITableViewCell {
    
    @IBOutlet weak var qtdLabel: UILabel!
    @IBOutlet weak var unidadeLabel: UILabel!
    @IBOutlet weak var ingredienteLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
