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
        self.recipeDetailTableView.register(UINib(nibName: "IngredientesTituloCell", bundle: nil), forCellReuseIdentifier: "IngredientesTituloCell")
        self.recipeDetailTableView.register(UINib(nibName: "IngredientesCell", bundle: nil), forCellReuseIdentifier: "IngredientesCell")
        self.recipeDetailTableView.register(UINib(nibName: "StepsToPrepareTituloCell", bundle: nil), forCellReuseIdentifier: "StepsToPrepareTituloCell")
        self.recipeDetailTableView.register(UINib(nibName: "StepsToPrepareCell", bundle: nil), forCellReuseIdentifier: "StepsToPrepareCell")
        self.recipeDetailTableView.register(UINib(nibName: "AvaliationTituloCell", bundle: nil), forCellReuseIdentifier: "AvaliationTituloCell")
        self.recipeDetailTableView.register(UINib(nibName: "AvaliationCell", bundle: nil), forCellReuseIdentifier: "AvaliationCell")
        self.recipeDetailTableView.register(UINib(nibName: "SeeMoreAndAvaliationCell", bundle: nil), forCellReuseIdentifier: "SeeMoreAndAvaliationCell")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell:ImageCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell
            return cell ?? UITableViewCell()
        case 1:
            let cell:IngredientesTituloCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "IngredientesTituloCell", for: indexPath) as? IngredientesTituloCell
            return cell ?? UITableViewCell()
        case 2:
            let cell:IngredientesCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "IngredientesCell", for: indexPath) as? IngredientesCell
            return cell ?? UITableViewCell()
        case 3:
            let cell:StepsToPrepareTituloCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "StepsToPrepareTituloCell", for: indexPath) as? StepsToPrepareTituloCell
            return cell ?? UITableViewCell()
        case 4:
            let cell:StepsToPrepareCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "StepsToPrepareCell", for: indexPath) as? StepsToPrepareCell
            return cell ?? UITableViewCell()
        case 5:
            let cell:AvaliationTituloCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "AvaliationTituloCell", for: indexPath) as? AvaliationTituloCell
            return cell ?? UITableViewCell()
        case 6:
            let cell:AvaliationCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "AvaliationCell", for: indexPath) as? AvaliationCell
            return cell ?? UITableViewCell()
        default:
            let cell:SeeMoreAndAvaliationCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "SeeMoreAndAvaliationCell", for: indexPath) as? SeeMoreAndAvaliationCell
            return cell ?? UITableViewCell()
        }
        
//        let cell:IngredientesTituloCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "IngredientesTituloCell", for: indexPath) as? IngredientesTituloCell
//        cell?.nameLabel.text = self.receita?.name
//        cell?.categoryLabel.text = self.receita?.category
//        cell?.timeLabel.text = self.receita?.time
//        cell?.servingsLabel.text = self.receita?.servings
//        cell?.setup(receita: self.arrayreceitas[indexPath.row])
        
//        return cell ?? UITableViewCell()
    }
    
    
    
    
}
