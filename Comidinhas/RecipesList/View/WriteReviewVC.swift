//
//  WriteReviewVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 30/10/20.
//

import UIKit

protocol WriteReviewVCDelegate: AnyObject {
    func savedReview(_ review: Reviews) -> Void
}


class WriteReviewVC: UIViewController, UITextFieldDelegate {
    
    var delegate: WriteReviewVCDelegate?
    var review: Reviews?
    private var recipe: Recipe?
    
    
    // IBOutlet View de Detalhes
    @IBOutlet private weak var recipeMeta: RecipeMetadataView!
    // IBOutlet View de Avaliação
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
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.review = Reviews(usuario: AppUserManager.shared.loggedUser?.name ?? "Karen Makihara", estrelas: self.starsLabel.text ?? "", data: dateFormatter.string(from: Date()), comentario: reviewTextField.text ?? "")
        print(review ?? "")
        arrayReviews.insert(review!, at: 0)
        
        // Invoca comportamento do nosso delegate!
        if let _review = self.review {
            self.delegate?.savedReview(_review)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Setup Method
    func configureWith(recipe: Recipe?) {
        self.recipe = recipe
    }
    
    private func setup() {
        self.recipeMeta.configureViewWith(recipe: self.recipe)
        self.recipeMeta.loggedUserNeedDelegate = self
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
