//
//  ReviewsVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 30/10/20.
//

import UIKit

class AllReviewsVC: UIViewController {

    // Propriedades internas.
    private var recipe: Recipe?
    
    // IBOutlet da View de Detalhes
    @IBOutlet private weak var recipeMeta: RecipeMetadataView!
    // IBOutlet da TableView
    @IBOutlet weak var reviewsTableView: UITableView!
    

    private func configTableView() {
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
        self.reviewsTableView.tableFooterView = UIView(frame: .zero)
        
        self.reviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.reviewsTableView.register(UINib(nibName: "ReviewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReviewHeaderCell")
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
//        let tapGestureToFavoriteLabel = UITapGestureRecognizer(target: self, action: #selector(panInFavoriteLabel(sender:)))
//        tapGestureToFavoriteLabel.numberOfTapsRequired = 1
//        self.favoriteLabel.isUserInteractionEnabled = true
//        self.favoriteLabel.addGestureRecognizer(tapGestureToFavoriteLabel)
    }
    
    
    // MARK: func panInFavoriteLabel
    
    @objc func panInFavoriteLabel(sender: UIGestureRecognizer) {
//        if self.favoriteLabel.text == "♡" {
//            self.favoriteLabel.text = "♥︎"
//        } else {
//            self.favoriteLabel.text = "♡"
//        }
    }
    
    // Método de configuração do view controller.
    func configureWith(recipe: Recipe?) {
        self.recipe = recipe
    }
    
    // Método de configuração das views, interno.
    private func setup() {
        self.recipeMeta.configureViewWith(recipe: self.recipe)
        self.configTableView()
    }

}




extension AllReviewsVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:ReviewHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReviewHeaderCell") as? ReviewHeaderCell
        var average: String = ""
        var media = starAverage()
        if media == 1 {
            average = "★☆☆☆☆"
        } else if media == 2 {
            average = "★★☆☆☆"
        } else if media == 3 {
            average = "★★★☆☆"
        } else if media == 4 {
            average = "★★★★☆"
        } else {
            average = "★★★★★"
        }
        header?.starLabel.text = average
//        header?.starLabel.text = "★★★★☆"
//        header?.starLabel.text = starAverage()
        header?.totalReviewsLabel.text = String(arrayReviews.count) + " reviews"
        return header ?? nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReviews.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewCell? = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        cell?.setupReview(review: arrayReviews[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
