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
    
    
    var receita:Recipe?
    

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
    
    
    private func configDetalhes() {
        self.nomeLabel.text = "Chocolate cake"
        self.categoriaLabel.text = "Desert"
        self.tempoLabel.text = "40 min"
        self.servingsLabel.text = "40 servings"
    }
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configDetalhes()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 + 2 + 2  // 2 partes para os ingredientes + 2 partes para o passo a passo
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header:IngredientesHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IngredientesHeaderCell") as? IngredientesHeaderCell
            header?.partOfTheRecipeLabel.text = arrayPartesDaReceita[0]
            return header ?? UITableViewHeaderFooterView()
        } else if section == 2 {
            let header:IngredientesHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "IngredientesHeaderCell") as? IngredientesHeaderCell
            header?.partOfTheRecipeLabel.text = arrayPartesDaReceita[1]
            return header ?? UITableViewHeaderFooterView()
        } else if section == 3 {
            let header:StepsHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StepsHeaderCell") as? StepsHeaderCell
            header?.partOfTheRecipeLabel.text = arrayPartesDaReceita[0]
            return header ?? UITableViewHeaderFooterView()
        } else if section == 4 {
            let header:StepsHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StepsHeaderCell") as? StepsHeaderCell
            header?.partOfTheRecipeLabel.text = arrayPartesDaReceita[1]
            return header ?? UITableViewHeaderFooterView()
        } else if section == 5 {
            let header:ReviewHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReviewHeaderCell") as? ReviewHeaderCell
            header?.starLabel.text = "★★★★☆"
            header?.totalReviewsLabel.text = String(arrayReviews.count) + " reviews"
            return header ?? nil
        }
        return UITableViewHeaderFooterView()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 6:
            return 0
        case 1, 2, 3, 4:
            return 44
        case 5:
            return 56
        default:
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 6:
            return 1
        case 1:
            return arrayIngredientesDough.count
        case 2:
            return arrayIngredientesIcing.count
        case 3:
            return arrayStepsDough.count
        case 4:
            return arrayStepsIcing.count
        case 5:
            return 3
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell:ImageCell? = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell
            cell?.recipeImageView.image = UIImage(named: "ChocolateCake")
            return cell ?? UITableViewCell()
        case 1:
            let cell:IngredientesCell? = tableView.dequeueReusableCell(withIdentifier: "IngredientesCell", for: indexPath) as? IngredientesCell
            cell?.setupIngredientes(ingredientes: arrayIngredientesDough[indexPath.row])
            return cell ?? UITableViewCell()
        case 2:
            let cell:IngredientesCell? = tableView.dequeueReusableCell(withIdentifier: "IngredientesCell", for: indexPath) as? IngredientesCell
            cell?.setupIngredientes(ingredientes: arrayIngredientesIcing[indexPath.row])
            return cell ?? UITableViewCell()
        case 3:
            let cell:StepToStepCell? = tableView.dequeueReusableCell(withIdentifier: "StepToStepCell", for: indexPath) as? StepToStepCell
            cell?.setupStep(step: arrayStepsDough[indexPath.row])
            return cell ?? UITableViewCell()
        case 4:
            let cell:StepToStepCell? = tableView.dequeueReusableCell(withIdentifier: "StepToStepCell", for: indexPath) as? StepToStepCell
            cell?.setupStep(step: arrayStepsIcing[indexPath.row])
            return cell ?? UITableViewCell()
        case 5:
            let cell:ReviewCell? = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
            cell?.setupReview(review: arrayReviews[indexPath.row])
            return cell ?? UITableViewCell()
        case 6:
            let cell:SeeMoreAndAvaliationCell? = tableView.dequeueReusableCell(withIdentifier: "SeeMoreAndAvaliationCell", for: indexPath) as? SeeMoreAndAvaliationCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
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
