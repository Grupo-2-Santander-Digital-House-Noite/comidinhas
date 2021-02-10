//
//  WriteReviewVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 30/10/20.
//

import UIKit

protocol WriteReviewVCDelegate: AnyObject {
    func savedReview(_ review: Review) -> Void
}


class WriteReviewVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Internal State
    var delegate: WriteReviewVCDelegate?
    var review: Review?
    private var recipe: Recipe?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var recipeMeta: RecipeMetadataView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var postReviewButton: UIButton!
    

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        // captura o toque na tela para avaliar a quantidade de estrelas
        let tapGestureToStarLabel = UITapGestureRecognizer(target: self, action: #selector(panInStarsLabel(sender:)))
        tapGestureToStarLabel.numberOfTapsRequired = 1
        self.starsLabel.isUserInteractionEnabled = true
        self.starsLabel.addGestureRecognizer(tapGestureToStarLabel)
        
        // configuração da textField
        self.reviewTextField.delegate = self
    }

    
    // MARK: func panInStarsLabel
    @objc func panInStarsLabel(sender: UIGestureRecognizer) {
        let locationView = sender.location(in: self.view)  // my finger position
        let newStarLabelFrame = self.view.convert(self.starsLabel.frame, from: self.starsLabel.superview)
        
        let frame1 = CGRect(x: newStarLabelFrame.origin.x, y: newStarLabelFrame.origin.y, width: newStarLabelFrame.size.width / 5, height: newStarLabelFrame.size.height)
        let frame2 = CGRect(x: newStarLabelFrame.origin.x, y: newStarLabelFrame.origin.y, width: 2 * newStarLabelFrame.size.width / 5, height: newStarLabelFrame.size.height)
        let frame3 = CGRect(x: newStarLabelFrame.origin.x, y: newStarLabelFrame.origin.y, width: 3 * newStarLabelFrame.size.width / 5, height: newStarLabelFrame.size.height)
        let frame4 = CGRect(x: newStarLabelFrame.origin.x, y: newStarLabelFrame.origin.y, width: 4 * newStarLabelFrame.size.width / 5, height: newStarLabelFrame.size.height)
        let frame5 = newStarLabelFrame
        
        
        if (frame1.contains(locationView)) {
            self.starsLabel.text = "★☆☆☆☆"
        } else if (frame2.contains(locationView)) {
            self.starsLabel.text = "★★☆☆☆"
        } else if (frame3.contains(locationView)) {
            self.starsLabel.text = "★★★☆☆"
        } else if (frame4.contains(locationView)) {
            self.starsLabel.text = "★★★★☆"
        } else if (frame5.contains(locationView)) {
            self.starsLabel.text = "★★★★★"
        }
        print(starsLabel.text ?? "")
    }
    
    
    // MARK: tappedPostReviewButton
    @IBAction func tappedPostReviewButton(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let userId = AppUserManager.shared.loggedUser?.uid ?? "0"
        let userFullName = AppUserManager.shared.loggedUser?.name ?? "Nobody"
        let recipeId = self.recipe?.id ?? 0
        let review = Review(recipeId: recipeId,
                            userId: userId,
                            date: Date(),
                            rating: Review.ratingFrom(stars: self.starsLabel.text ?? ""),
                            comment: self.reviewTextField.text ?? "",
                            userFullName: userFullName)
        
        AppReviews.shared.saveReview(review: review) {
            self.delegate?.savedReview(review)
            self.dismiss(animated: true, completion: nil)
        } failure: { (error) in
            self.dismiss(animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: Setup Method
    func configureWith(recipe: Recipe?, review: Review?) {
        self.recipe = recipe
        self.review = review
    }
    
    private func setup() {
        self.recipeMeta.configureViewWith(recipe: self.recipe)
        self.recipeMeta.loggedUserNeedDelegate = self
        
        if let review = self.review {
            self.postReviewButton.setTitle("Update", for: .normal)
            self.reviewTextField.text = review.comment
            self.starsLabel.text = review.ratingStars
        }
    }
}


// MARK: extension UITextField
extension WriteReviewVC: UITextViewDelegate {
    // faz baixar o teclado depois que clica em retornar
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.reviewTextField.resignFirstResponder()
        return true
    }
}


// MARK: - extension ViewNeedsLoggedUserDelegate
extension WriteReviewVC: ViewNeedsLoggedUserDelegate {
    
    func didNeedALoggedUserTo(reason: String) {
        self.displayConfirmationAlert(title: "Hey", message: reason) { (action) in
            if let tabbarcontroller = self.tabBarController as? MainTabBarController {
                tabbarcontroller.transitionTo(destinationTab: .Settings)
            } else {
                self.displayErrorAlertWith(title: "Error", message: "Can't login right now, please try again by tapping the settings icon.", completion: nil)
            }
        };
    }
}
