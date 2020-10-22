//
//  RecipesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipesVC: UIViewController {

    @IBOutlet weak var recipesListTableView: UITableView!
    
    
    var arrayreceitas:[Recipe] = [Recipe(name: "Chocolate cake", time: "40m", category: "Dessert", servings: "40 servings", image: "ChocolateCake"),
                             Recipe(name: "Rainbow cake", time: "3h 30m", category: "Dessert", servings: "16 servings", image: "RainbowCake"),
                             Recipe(name: "Tomato soup", time: "40m", category: "Soup", servings: "4 servings", image: "TomatoSoup"),
                             Recipe(name: "Chicken strogonoff", time: "1h", category: "Main course", servings: "4 servings", image: "ChickenStrogonoff"),
                             Recipe(name: "Hamburger", time: "30m", category: "Snack", servings: "2 servings", image: "Hamburger")]
    
    
    private func configTableView() {
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
        
        self.recipesListTableView.tableFooterView = UIView(frame: .zero)
        
        self.recipesListTableView.register(UINib(nibName: "RecipesCell", bundle: nil), forCellReuseIdentifier: "RecipesCell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
        // Do any additional setup after loading the view.
    }
    


}



extension RecipesVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayreceitas.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecipesCell? = self.recipesListTableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipesCell
        
        cell?.setup(receita: self.arrayreceitas[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "RecipeDetailVC", sender: "")
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receita:Recipe? = sender as? Recipe
        let vc = segue.destination as? RecipeDetailVC
        
        vc?.receita = receita
        
    }
    
}
