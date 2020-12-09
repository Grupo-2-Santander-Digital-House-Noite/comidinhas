//
//  SeeMoreAndAvaliationCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 26/10/20.
//

import UIKit

protocol SeeMoreAndAvaliationCellDelegate:class {
    func tappedAllReviews()
    func tappedWriteReview()
}


class SeeMoreAndAvaliationCell: UITableViewCell {
    
    weak var delegate:SeeMoreAndAvaliationCellDelegate?

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
        self.delegate?.tappedAllReviews()
    }
    
    
    @IBAction func tappedWriteReview(_ sender: UIButton) {
        print("tappedWriteReviewButton=====")
        if AppUserManager.shared.hasLoggedUser() { // eu
            self.delegate?.tappedWriteReview()
        } else { // daqui pra baixo eu
            print("=====VOCE PRECISA ESTAR LOGADO=====")
            let alert = UIAlertController(title: "Alert", message: "You need to be logged in to write a review", preferredStyle: .alert)
            let buttonOk = UIAlertAction(title: "OK", style: .default) { (success) in
                print("=====Ok - DEU CERTO=====")
            }
            let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
                print("======Cancel - DEU CERTO======")
            }
            alert.addAction(buttonOk)
            alert.addAction(buttonCancel)
//            self.present(alert, animated: true, completion: nil)
        }
    }
}
