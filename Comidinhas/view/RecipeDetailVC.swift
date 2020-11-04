//
//  RecipeDetailVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//


//"♡"♥︎
// ☆ ★

import UIKit

class RecipeDetailVC: UIViewController {

    // MARK: IBOutlet

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!

    @IBOutlet weak var detalheReceitaView: UIView!


    @IBOutlet weak var recipeDetailTableView: UITableView!


    var receita: Recipe?


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
        self.nomeLabel.text = receita?.name ?? "Chocolate cake"
        self.categoriaLabel.text = receita?.categoryString ?? "Desert"
        self.tempoLabel.text = "\(receita?.time ?? 40) min"
        self.servingsLabel.text = "\(receita?.servings ?? 40) servings"
    }


    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configDetalhes(self.receita)
        self.configTableView()
        self.detalheReceitaView.backgroundColor = UIColor(red: 1.00, green: 0.73, blue: 0.36, alpha: 1.00)

        //Adicionar Tap Gesture na label de favoritar
        let tapGestureToFavoriteLabel = UITapGestureRecognizer(target: self, action: #selector(panInFavoriteLabel(sender:)))
        tapGestureToFavoriteLabel.numberOfTapsRequired = 1
        favoriteLabel.isUserInteractionEnabled = true
        favoriteLabel.addGestureRecognizer(tapGestureToFavoriteLabel)
    }


    // MARK: func panInFavoriteLabel

    @objc func panInFavoriteLabel(sender: UIGestureRecognizer) {
        if self.favoriteLabel.text == "♡" {
            self.favoriteLabel.text = "♥︎"
        } else {
            self.favoriteLabel.text = "♡"
        }
    }

}



// MARK: extension Delegate, DataSouce

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {

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
            header?.starLabel.text = "★★★★☆"
            header?.totalReviewsLabel.text = String(arrayReviews.count) + " reviews"
            return header ?? nil
        }

        let header: IngredientesHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IngredientesHeaderCell") as? IngredientesHeaderCell
        header?.partOfTheRecipeLabel.text = "Section: \(section)"
        return header ?? UITableViewHeaderFooterView()
    }



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
            return 3
        }

        return 0
    }


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
            cell?.recipeImageView.image = UIImage(named: self.receita?.image ?? "ChocolateCake")
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
            cell?.setupReview(review: arrayReviews[indexPath.row])
            return cell ?? UITableViewCell()

        } else if section == verMaisAvaliacoesSection {

            let cell: SeeMoreAndAvaliationCell? = tableView.dequeueReusableCell(withIdentifier: "SeeMoreAndAvaliationCell", for: indexPath) as? SeeMoreAndAvaliationCell
            return cell ?? UITableViewCell()

        }

        return UITableViewCell()

    }
    
      
    private func getModoPreparoIndexFor(_ section: Int) -> Int {
        let modoPreparoSectionMax = (self.receita?.stepsSection.count ?? 0) + 1
        return section - 2
    }

}



extension RecipeDetailVC:SeeMoreAndAvaliationCellDelegate {
    func tappedAllReviews() {
        self.performSegue(withIdentifier: "AllReviewsVC", sender: "")
    }
    
    
    func tappedWriteReview() {
        self.performSegue(withIdentifier: "WriteReviewVC", sender: "")
    }
}
