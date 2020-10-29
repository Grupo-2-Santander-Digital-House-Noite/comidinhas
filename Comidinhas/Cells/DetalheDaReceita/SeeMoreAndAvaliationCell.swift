//
//  SeeMoreAndAvaliationCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 26/10/20.
//

import UIKit

class SeeMoreAndAvaliationCell: UITableViewCell {

    @IBOutlet weak var moreReviewsButton: UIButton!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func tappedMoreReviewButton(_ sender: UIButton) {
        print("tappedMoreReviewButton=====")
    }
    
    
    @IBAction func tappedWriteReview(_ sender: UIButton) {
        print("tappedWriteReviewButton=====")
    }
    
    
    
    
}
