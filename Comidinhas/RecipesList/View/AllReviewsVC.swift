//
//  ReviewsVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 30/10/20.
//

import UIKit

class AllReviewsVC: BaseViewController {

    // Propriedades internas.
    private var recipe: Recipe?
    
    var reviews: Reviews = []
    var reviewsLoadingState: ReviewsLoadingState = .Loading
    var recipeReviewMeta: RecipeReviewMetadata? = nil
    var recipeReviewMetaState: RecipeReviewMetadataLoadingState = .Loading
    
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
        
        self.showLoadingCooker()
        AppReviews.shared.loadRecipeReviewMetaDataWithRecipe(id: recipe?.id ?? 0, completion: loadedReviewMeta(reviewMeta:), failure: reviewMetaLoadErrorHandler(error:))
        AppReviews.shared.loadReviewsForRecipeWith(id: recipe?.id ?? 0, reviewsToLoad: nil) { (review) in
            self.hideLoadingCooker()
            self.loadedReviews(reviews: review)
        } failure: { (error) in
            self.hideLoadingCooker()
            self.reviewLoaderErrorHandler(error: error)
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func loadedReviews(reviews: Reviews) {
        self.reviews = reviews
        self.reviewsLoadingState = reviews.count > 0 ? ReviewsLoadingState.Loaded : ReviewsLoadingState.EmptyLoaded
        self.reviewsTableView.reloadData()
    }
    
    func reviewLoaderErrorHandler(error: Error) {
        self.reviews = []
        self.reviewsLoadingState = ReviewsLoadingState.Error
        self.reviewsTableView.reloadData()
    }
    
    func loadedReviewMeta(reviewMeta: RecipeReviewMetadata) {
        self.recipeReviewMeta = reviewMeta
        self.recipeReviewMetaState = .Loaded
        self.reviewsTableView.reloadData()
    }
    
    func reviewMetaLoadErrorHandler(error: Error) {
        self.recipeReviewMetaState = .Error
        self.reviewsTableView.reloadData()
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
        switch self.recipeReviewMetaState {
        case .Loading :
            average = "Loading average ratings"
            header?.totalReviewsLabel.text = "* reviews"
        case .Loaded :
            average = self.recipeReviewMeta?.ratingStars ?? "Error converting"
            header?.totalReviewsLabel.text = "\(self.recipeReviewMeta?.reviewCount ?? 0) reviews"
        case .Error :
            average = "Could not load average"
            header?.totalReviewsLabel.text = "0 reviews"
        }
        header?.starLabel.text = average
        return header ?? nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewCell? = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        
        switch self.reviewsLoadingState {
        case .Loading:
            cell?.setupLoading()
        case .EmptyLoaded:
            cell?.setupNoReview()
        case .Loaded:
            cell?.setupReview(review: self.reviews[indexPath.row])
        case .Error:
            cell?.setupError(error: GenericError.GenericErrorWithMessage(message: "Could not load the reviews"))
        }
        
        return cell ?? UITableViewCell()
    }
}


// MARK: - extension ViewNeedsLoggedUserDelegate
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


