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
    

    // MARK: configTableView
    
    private func configTableView() {
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
        self.reviewsTableView.tableFooterView = UIView(frame: .zero)
        
        self.reviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.reviewsTableView.register(UINib(nibName: "ReviewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReviewHeaderCell")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
  
    // Método de configuração do view controller.
    func configureWith(recipe: Recipe?) {
        self.recipe = recipe
    }
    
    // Método de configuração das views, interno.
    private func setup() {
        self.recipeMeta.configureViewWith(recipe: self.recipe)
        self.recipeMeta.loggedUserNeedDelegate = self
        self.configTableView()
    }
}


// MARK: extension TableView

extension AllReviewsVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header:ReviewHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReviewHeaderCell") as? ReviewHeaderCell
        var average: String = ""
        var media = starAverage()
        switch media {
        case 1:
            average = "★☆☆☆☆"
        case 2:
            average = "★★☆☆☆"
        case 3:
            average = "★★★☆☆"
        case 4:
            average = "★★★★☆"
        case 5:
            average = "★★★★★"
        default:
            average = "☆☆☆☆☆"
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

extension AllReviewsVC : ViewNeedsLoggedUserDelegate {
    
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


