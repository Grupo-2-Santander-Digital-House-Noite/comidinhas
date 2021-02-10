//
//  ErrorAndEmptyCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 17/12/20.
//

import UIKit

class ErrorAndEmptyCell: UITableViewCell {
    
    @IBOutlet weak var titleMessageLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var instructionOneLabel: UILabel!
    @IBOutlet weak var instructionTwoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupEmpty() {
        self.titleMessageLabel.text = "Your favorites list is empty."
        self.statusImageView.image = UIImage(named: "sadHeart")
        self.instructionOneLabel.text = "To add recipes to your favorites list you need to be logged in."
        self.instructionTwoLabel.text = "Then, just click on the recipe's heart"
    }
    
    
    func setupError() {
        self.titleMessageLabel.text = "Oh no! Something went wrong!"
        self.statusImageView.image = UIImage(named: "sadFace")
        self.instructionOneLabel.text = "Please, try again latter"
        self.instructionTwoLabel.text = ""
    }
}
