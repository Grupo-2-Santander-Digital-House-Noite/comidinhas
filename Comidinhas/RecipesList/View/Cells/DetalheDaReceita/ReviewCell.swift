//
//  AvaliationCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 26/10/20.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var usuarioEstrelasLabel: UILabel!
    @IBOutlet weak var usuarioDataLabel: UILabel!
    @IBOutlet weak var usuarioComentarioLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupReview(review:Reviews) {
        self.usuarioLabel.text = review.usuario
        self.usuarioEstrelasLabel.text = review.estrelas
        self.usuarioDataLabel.text = review.data
        self.usuarioComentarioLabel.text = review.comentario
    }
    
    func setupNoReview() {
        self.usuarioLabel.text = ""
        self.usuarioEstrelasLabel.text = ""
        self.usuarioDataLabel.text = ""
        self.usuarioComentarioLabel.text = "No review"
    }
    
}
