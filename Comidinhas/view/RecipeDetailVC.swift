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
    

    // MARK: configTableView
    
    private func configTableView() {
        self.recipeDetailTableView.delegate = self
        self.recipeDetailTableView.dataSource = self
        
        self.recipeDetailTableView.tableFooterView = UIView(frame: .zero)
        
        self.recipeDetailTableView.register(UINib(nibName: "ResumoDaReceitaCell", bundle: nil), forCellReuseIdentifier: "ResumoDaReceitaCell")
    }
    
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTableView()
        self.detalheReceitaView.backgroundColor = UIColor(red: 1.00, green: 0.73, blue: 0.36, alpha: 1.00)
        
        let tapGestureToFavoriteLabel = UITapGestureRecognizer(target: self, action: #selector(panInFavoriteLabel(sender:)))
        tapGestureToFavoriteLabel.numberOfTapsRequired = 1
        favoriteLabel.isUserInteractionEnabled = true
        favoriteLabel.addGestureRecognizer(tapGestureToFavoriteLabel)
    }
    
    
    // MARK: @obj func panInFavoriteLabel
    
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResumoDaReceitaCell? = self.recipeDetailTableView.dequeueReusableCell(withIdentifier: "ResumoDaReceitaCell", for: indexPath) as? ResumoDaReceitaCell
        cell?.nameLabel.text = self.receita?.name
        cell?.categoryLabel.text = self.receita?.category
        cell?.timeLabel.text = self.receita?.time
        cell?.servingsLabel.text = self.receita?.servings
//        cell?.setup(receita: self.arrayreceitas[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    
    
    
}
