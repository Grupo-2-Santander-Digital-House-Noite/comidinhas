//
//  RecipesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipesVC: UIViewController {

    @IBOutlet weak var recipesListTableView: UITableView!
    @IBOutlet weak var serachBarButton: UIBarButtonItem!
    
    
    // MARK: configTableView
    
    private func configTableView() {
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
        
        self.recipesListTableView.tableFooterView = UIView(frame: .zero)
        
        self.recipesListTableView.register(UINib(nibName: "RecipesCell", bundle: nil), forCellReuseIdentifier: "RecipesCell")
    }
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: IBAction serachBarButtonClick
    
    @IBAction func searchBarButtonClick(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController: SearchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        newViewController.modalPresentationStyle = .overFullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}


// MARK: extension TableView

extension RecipesVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipesWebService.shared.recipes.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecipesCell? = self.recipesListTableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipesCell
        
        cell?.setup(receita: RecipesWebService.shared.recipes[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "RecipeDetailVC", sender: RecipesWebService.shared.recipes[indexPath.row])
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receita:Recipe? = sender as? Recipe
        let vc = segue.destination as? RecipeDetailVC
        
        vc?.receita = receita
    }
}
