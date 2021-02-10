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
    func tappedUpdateReview(review: Review)
}


class SeeMoreAndAvaliationCell: UITableViewCell {
    
    // MARK: - Internal State and Properties
    weak var delegate:SeeMoreAndAvaliationCellDelegate?
    weak var viewNeedLoggedUserDelegate: ViewNeedsLoggedUserDelegate?
    var review: Review?
    
    // MARK: - IBOutlets
    @IBOutlet weak var moreReviewsButton: UIButton!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupWithReview(review: Review?) {
        self.review = review
        self.updateButton()
    }
    
    
    func updateButton() {
        var title: String = self.review != nil ? "Update review" : "Write a review"
        self.writeReviewButton.setTitle(title, for: .normal)
    }
    
    
    @IBAction func tappedMoreReviewButton(_ sender: UIButton) {
        print("tappedMoreReviewButton=====")
        self.delegate?.tappedAllReviews()
    }
    
    
    @IBAction func tappedWriteReview(_ sender: UIButton) {
        print("tappedWriteReviewButton=====")
        if !AppUserManager.shared.hasLoggedUser() { // eu
            self.viewNeedLoggedUserDelegate?.didNeedALoggedUserTo( reason: "You need to be logged in to write a review")
            return
        }
        
        
        if let review = self.review {
            self.delegate?.tappedUpdateReview(review: review)
        } else {
            self.delegate?.tappedWriteReview()
        }
    }
}
