//
//  RecipeDetailVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//


import UIKit

class RecipeDetailVC: UIViewController {

    let SEGUE_ID_ALL_REVIEWS_VC = "AllReviewsVC"
    let SEGUE_ID_WRITE_REVIEW_VC = "WriteReviewVC"
    
    // MARK: - Internal State
    var reviews: Reviews = []
    var reviewsLoadingState: ReviewsLoadingState = .Loading
    var recipeReviewMeta: RecipeReviewMetadata? = nil
    var recipeReviewMetaState: RecipeReviewMetadataLoadingState = .Loading
    var receita: Recipe?
    
    // MARK: - IBOutlet
    @IBOutlet weak var detalheReceitaView: UIView!
    @IBOutlet weak var recipeMetaView: RecipeMetadataView!
    @IBOutlet weak var recipeDetailTableView: UITableView!


    // MARK: configTableView e configDetalhes
    private func configTableView() {
        self.recipeDetailTableView.delegate = self
        self.recipeDetailTableView.dataSource = self

        self.recipeDetailTableView.tableFooterView = UIView(frame: .zero)

        // Registro das células
        self.recipeDetailTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        self.recipeDetailTableView.register(UINib(nibName: "IngredientesCell", bundle: nil), forCellReuseIdentifier: "IngredientesCell")
        self.recipeDetailTableView.register(UINib(nibName: "StepToStepCell", bundle: nil), forCellReuseIdentifier: "StepToStepCell")
        self.recipeDetailTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.recipeDetailTableView.register(UINib(nibName: "SeeMoreAndAvaliationCell", bundle: nil), forCellReuseIdentifier: "SeeMoreAndAvaliationCell")
        
        // Registro das Headers
        self.recipeDetailTableView.register(UINib(nibName: "IngredientesHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "IngredientesHeaderCell")
        self.recipeDetailTableView.register(UINib(nibName: "StepsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "StepsHeaderCell")
        self.recipeDetailTableView.register(UINib(nibName: "ReviewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ReviewHeaderCell")
    }


    private func configDetalhes(_ receita: Recipe?) {
        self.recipeMetaView.configureViewWith(recipe: receita)
        self.recipeMetaView.loggedUserNeedDelegate = self
    }

    // MARK: - Ciclo de vida e registro de notificações
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeDetailTableView.allowsSelection = false 
        self.configDetalhes(self.receita)
        self.configTableView()
        self.configureNotifications();
        
        AppReviews.shared.loadReviewsForRecipeWith(id: self.receita?.id ?? 0, reviewsToLoad: 5, completion: loadedReviews(reviews:), failure: reviewLoaderErrorHandler(error:))
        AppReviews.shared.loadRecipeReviewMetaDataWithRecipe(id: self.receita?.id ?? 0, completion: loadedReviewMeta(reviewMeta:), failure: reviewMetaLoadErrorHandler(error:))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: AppUserManager.userLoggedInNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: AppUserManager.userLoggedOutNotification, object: nil)
    }
    
    
    @objc private func reloadData() {
        self.recipeDetailTableView.reloadData()
    }
    
    
    // MARK: - Handlers das reviews (Mover para um controller)
    func loadedReviews(reviews: Reviews) {
        self.reviews = reviews
        self.reviewsLoadingState = reviews.count > 0 ? ReviewsLoadingState.Loaded : ReviewsLoadingState.EmptyLoaded
        self.recipeDetailTableView.reloadData()
    }
    
    func reviewLoaderErrorHandler(error: Error) {
        self.reviews = []
        self.reviewsLoadingState = ReviewsLoadingState.Error
        self.recipeDetailTableView.reloadData()
    }
    
    func loadedReviewMeta(reviewMeta: RecipeReviewMetadata) {
        self.recipeReviewMeta = reviewMeta
        self.recipeReviewMetaState = .Loaded
        self.recipeDetailTableView.reloadData()
    }
    
    func reviewMetaLoadErrorHandler(error: Error) {
        self.recipeReviewMetaState = .Error
        self.recipeDetailTableView.reloadData()
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: SEGUE HANDLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Esta classe usa dois possíveis segues.
        switch segue.identifier {
        case self.SEGUE_ID_ALL_REVIEWS_VC:
            // passa dados ao Destination do ALL REVIEWS
            let vc: AllReviewsVC? = segue.destination as? AllReviewsVC
            vc?.configureWith(recipe: self.receita)
            break
        case self.SEGUE_ID_WRITE_REVIEW_VC:
            // passa dados ao Destination do WRITE REVIEWS
            let vc: WriteReviewVC? = segue.destination as? WriteReviewVC
            vc?.delegate = self
            
            var userReview: Review? = sender as? Review
            
            vc?.configureWith(recipe: self.receita, review: userReview)
            break
        default:
            return
        }
    }
}



// MARK: - Extension: TableView Delegate e DataSouce
extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {

    // MARK: Helpers for sections
    var numSectionCabecalho: Int {
        get { return 1 }
    }
    var numSectionIngredientes: Int {
        get { return 1 }
    }
    var numSectionsModosPreparo: Int {
        get { self.receita?.stepsSection.count ?? 0 }
    }
    var numSectionReviews: Int {
        get { return 1 }
    }
    var numSectionsViewMoreReviews: Int {
        get { return 1 }
    }

    
    // MARK: leadingSwipeActionsConfigurationForRowAt indexPath
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section != 1 {
            return nil
        }
        
        let index: Int = indexPath.row
        
        let addAction: UIContextualAction = UIContextualAction(style: .normal, title: "Adicionar") { (contextualAction, uiView, completionHandler) in
            // Tenta obter ingrediente para passar para frente.
            if let ingredient: Ingredients = self.receita?.ingredients?[index] {
                ShoppingList.shared.add(ingredient: IngredientEntry(with: ingredient))
            }
            
            // TODO: Adicionar comportamento de adicionar a lista de compras.
            completionHandler(false)
        }
        
        addAction.backgroundColor = .systemGreen
        addAction.image = UIImage(systemName: "cart.badge.plus")
        
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    

    // MARK: Number Of Sections
    // Define quantas seções tem a table view
    func numberOfSections(in tableView: UITableView) -> Int {

        /**
         O número de seções é formado por:
         1. Cabeçalho.
         2. Ingredientes
         3. Modos de preparo
         4. Avaliações
         5. Ver mais avaliações.
         */

        return self.numSectionCabecalho + self.numSectionIngredientes + self.numSectionsModosPreparo + self.numSectionReviews + self.numSectionsViewMoreReviews // 2 partes para os ingredientes + 2 partes para o passo a passo
    }


    // MARK: View For Header In Section
    // define as headers de cada section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cabecalhoSection = 0
        let ingredientesSection = 1
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        let avaliacoesSection = modoPreparoSectionMax + 1
        let verMaisAvaliacoesSection = avaliacoesSection + 1

        if section == ingredientesSection {
            let header: IngredientesHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IngredientesHeaderCell") as? IngredientesHeaderCell
            header?.partOfTheRecipeLabel.text = ""
            return header ?? UITableViewHeaderFooterView()
        } else if 0 < (self.receita?.stepsSection.count as? Int ?? 0) && (section >= 2 && section <= modoPreparoSectionMax) {

            let sectionTitle = self.receita?.stepsSection[ self.getModoPreparoIndexFor(section) ].name ?? ""

            let header: StepsHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StepsHeaderCell") as? StepsHeaderCell
            header?.partOfTheRecipeLabel.text = sectionTitle
            return header ?? UITableViewHeaderFooterView()
        } else if section == avaliacoesSection {
            let header: ReviewHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReviewHeaderCell") as? ReviewHeaderCell
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

        let header: IngredientesHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IngredientesHeaderCell") as? IngredientesHeaderCell
        header?.partOfTheRecipeLabel.text = "Section: \(section)"
        return header ?? UITableViewHeaderFooterView()
    }


    // MARK: Height For Header In Section
    // define a altura de cada header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        // Section 0 - Cabeçalho
        // Section 1 - Ingredientes
        // Section 2 até 1+stepsCount -> Modo preparo
        // Section modo de preparo + 1 -> avaliações.
        // Section avaliacoes+1 -> ver mais avaliações.

        let cabecalhoSection = 0
        let ingredientesSection = 1
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        let avaliacoesSection = modoPreparoSectionMax + 1
        let verMaisAvaliacoesSection = avaliacoesSection + 1

        if section == cabecalhoSection || section == verMaisAvaliacoesSection {
            return 0
        } else if section == ingredientesSection {
            return 44
        } else if 0 < (self.receita?.stepsSection.count ?? 0) && (section >= 2 && section <= modoPreparoSectionMax) {
            return 44
        } else if section == avaliacoesSection {
            return 56
        }

        return 44
    }


    // MARK: Number Of Rows In Section
    // define quantas células terá em cada section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Section 0 - Cabeçalho
        // Section 1 - Ingredientes
        // Section 2 até 1+stepsCount -> Modo preparo
        // Section modo de preparo + 1 -> avaliações.
        // Section avaliacoes+1 -> ver mais avaliações.

        let cabecalhoSection = 0
        let ingredientesSection = 1
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        let avaliacoesSection = modoPreparoSectionMax + 1
        let verMaisAvaliacoesSection = avaliacoesSection + 1

        if section == cabecalhoSection || section == verMaisAvaliacoesSection {
            return 1
        } else if section == ingredientesSection {
            return self.receita?.ingredients?.count ?? 0
        } else if 0 < (self.receita?.stepsSection.count ?? 0) && (section >= 2 && section <= modoPreparoSectionMax) {
            return self.receita?.stepsSection[ self.getModoPreparoIndexFor(section) ].steps.count ?? 0
        } else if section == avaliacoesSection {
            
            switch self.reviewsLoadingState {
            case .EmptyLoaded:
                return 1
            case .Error:
                return 1
            case .Loading:
                return 1
            default:
                return self.reviews.count
            }
            
        }
        return 0
    }

    
    // MARK: Cell for Row At IndexPath
    // constrói cada célula dependendo da section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Section 0 - Cabeçalho
        // Section 1 - Ingredientes
        // Section 2 até 1+stepsCount -> Modo preparo
        // Section modo de preparo + 1 -> avaliações.
        // Section avaliacoes+1 -> ver mais avaliações.

        let cabecalhoSection = 0
        let ingredientesSection = 1
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        let avaliacoesSection = modoPreparoSectionMax + 1
        let verMaisAvaliacoesSection = avaliacoesSection + 1

        let section = indexPath.section

        if section == cabecalhoSection {

            let cell: ImageCell? = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell
            //cell?.recipeImageView.image = UIImage(named: self.receita?.image ?? "ChocolateCake")
            if let url = URL(string: self.receita?.image ?? ""){
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() { [weak self] in
                        cell?.recipeImageView.image = image
                    }
                }.resume()
            }
            return cell ?? UITableViewCell()

        } else if section == ingredientesSection {

            if let _ingredientes = self.receita?.ingredients {
                let cell: IngredientesCell? = tableView.dequeueReusableCell(withIdentifier: "IngredientesCell", for: indexPath) as? IngredientesCell
                cell?.setupIngredientes(ingredientes: _ingredientes[indexPath.row])
                return cell ?? UITableViewCell()
            }

        } else if (self.receita?.stepsSection.count ?? 0) > 0 && (section >= 2 && section <= modoPreparoSectionMax) {

            if let _modoPreparo = self.receita?.stepsSection {

                let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1

                let cell: StepToStepCell? = tableView.dequeueReusableCell(withIdentifier: "StepToStepCell", for: indexPath) as? StepToStepCell
                cell?.setupStep(step: _modoPreparo[ self.getModoPreparoIndexFor(section) ].steps[indexPath.row])
                return cell ?? UITableViewCell()
            }

        } else if section == avaliacoesSection {

            let cell: ReviewCell? = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
            
            switch self.reviewsLoadingState {
            case .EmptyLoaded:
                cell?.setupNoReview()
            case .Loading:
                cell?.setupLoading()
            case .Error:
                cell?.setupError(error: GenericError.GenericErrorWithMessage(message: "Could not load the reviews"))
            case .Loaded:
                cell?.setupReview(review: reviews[indexPath.row])
            default:
                cell?.setupError(error: GenericError.GenericErrorWithMessage(message: "Unknow error!"))
            }
            
            return cell ?? UITableViewCell()
            
        } else if section == verMaisAvaliacoesSection {

            let cell: SeeMoreAndAvaliationCell? = tableView.dequeueReusableCell(withIdentifier: "SeeMoreAndAvaliationCell", for: indexPath) as? SeeMoreAndAvaliationCell
            cell?.delegate = self
            cell?.viewNeedLoggedUserDelegate = self
            if let userId = AppUserManager.shared.loggedUser?.uid,
                let userReview = self.reviews.filter({ (review) -> Bool in
                    return review.userId == userId
                }).first {
                cell?.setupWithReview(review: userReview)
            }
            return cell ?? UITableViewCell()
        }

        return UITableViewCell()
    }
    
     
    // MARK: get modo de preparo index for
    private func getModoPreparoIndexFor(_ section: Int) -> Int {
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        return section - 2
    }

}


// MARK: - Extension Delegate for Review Related Stuff
extension RecipeDetailVC: SeeMoreAndAvaliationCellDelegate, WriteReviewVCDelegate {
    func savedReview(_ review: Review) {
        // Nesse momento só atualizamos a tabela de reviews.
        AppReviews.shared.loadReviewsForRecipeWith(id: self.receita?.id ?? 0, reviewsToLoad: 5, completion: loadedReviews(reviews:), failure: reviewLoaderErrorHandler(error:))
        AppReviews.shared.loadRecipeReviewMetaDataWithRecipe(id: self.receita?.id ?? 0, completion: loadedReviewMeta(reviewMeta:), failure: reviewMetaLoadErrorHandler(error:))
        
        self.recipeReviewMetaState = .Loading
        self.reviewsLoadingState = .Loading
    }
    
    
    func tappedAllReviews() {
        self.performSegue(withIdentifier: "AllReviewsVC", sender: "")
    }
    
    
    func tappedWriteReview() {
        self.performSegue(withIdentifier: "WriteReviewVC", sender: "")
    }
    
    func tappedUpdateReview(review: Review) {
        self.performSegue(withIdentifier: "WriteReviewVC", sender: review)
    }
}

// MARK: - Extension for reason for login
extension RecipeDetailVC: ViewNeedsLoggedUserDelegate {
    
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
