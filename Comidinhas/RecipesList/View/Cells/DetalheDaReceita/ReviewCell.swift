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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupReview(review:Review) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        self.usuarioLabel.text = review.userFullName
        self.usuarioEstrelasLabel.text = review.ratingStars
        self.usuarioDataLabel.text = formatter.string(from: review.date)
        self.usuarioComentarioLabel.text = review.comment
    }
    
    
    func setupNoReview() {
        self.usuarioLabel.text = ""
        self.usuarioEstrelasLabel.text = ""
        self.usuarioDataLabel.text = ""
        self.usuarioComentarioLabel.text = "No review"
    }
    
    
    func setupLoading() {
        self.usuarioLabel.text = ""
        self.usuarioEstrelasLabel.text = ""
        self.usuarioDataLabel.text = ""
        self.usuarioComentarioLabel.text = "Loading"
    }
    
    
    func setupError(error: Error) {
        self.usuarioLabel.text = ""
        self.usuarioEstrelasLabel.text = ""
        self.usuarioDataLabel.text = ""
        self.usuarioComentarioLabel.text = error.localizedDescription
    }
}
