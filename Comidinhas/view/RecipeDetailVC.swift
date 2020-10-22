//
//  RecipeDetailVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var recipeDetailTableView: UITableView!
    
    
    var receita:Recipe?
    

    private func configTableView() {
        self.recipeDetailTableView.delegate = self
        self.recipeDetailTableView.dataSource = self
        
        self.recipeDetailTableView.tableFooterView = UIView(frame: .zero)
        
        self.recipeDetailTableView.register(UINib(nibName: "ResumoDaReceitaCell", bundle: nil), forCellReuseIdentifier: "ResumoDaReceitaCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTableView()

        
    }

}



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
