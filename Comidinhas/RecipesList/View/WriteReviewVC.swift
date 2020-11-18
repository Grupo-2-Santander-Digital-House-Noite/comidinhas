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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        // seta o coração de favoritar
//        let tapGestureToFavoriteLabel = UITapGestureRecognizer(target: self, action: #selector(panInFavoriteLabel(sender:)))
//        tapGestureToFavoriteLabel.numberOfTapsRequired = 1
//        self.favoriteLabel.isUserInteractionEnabled = true
//        self.favoriteLabel.addGestureRecognizer(tapGestureToFavoriteLabel)
        
        // seta as estrelas da avaliação
        let tapGestureToStarLabel = UITapGestureRecognizer(target: self, action: #selector(panInStarsLabel(sender:)))
        tapGestureToStarLabel.numberOfTapsRequired = 1
        self.starsLabel.isUserInteractionEnabled = true
        self.starsLabel.addGestureRecognizer(tapGestureToStarLabel)
        
        
        // configuração da textField
        self.reviewTextField.delegate = self
    }
    
 
    
    // MARK: func panInFavoriteLabel
    
    @objc func panInFavoriteLabel(sender: UIGestureRecognizer) {
//        if self.favoriteLabel.text == "♡" {
//            self.favoriteLabel.text = "♥︎"
//        } else {
//            self.favoriteLabel.text = "♡"
//        }
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
        self.review = Reviews(usuario: "Karen Makihara", estrelas: self.starsLabel.text ?? "", data: dateFormatter.string(from: Date()), comentario: reviewTextField.text ?? "")
        print(review ?? "")
//        guard let _review = self.review else {
//            return Reviews(usuario: "", estrelas: "", data: "", comentario: "")
//        }
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
    }
    

}


extension WriteReviewVC: UITextViewDelegate {
    // faz baixar o teclado depois que clica em retornar
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.reviewTextField.resignFirstResponder()
        return true
    }
}
