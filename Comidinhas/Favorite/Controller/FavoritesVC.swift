//
//  FavoritesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class FavoritesVC: UIViewController, FavoriteControllerUpdate {
    
    
    // MARK: Controller
    var controller: FavoritesController = FavoritesController()
    
    // MARK: IBoutlet
    @IBOutlet weak var favoritesTableView: UITableView!
    
    
    // MARK: configuação TableView
    private func configTableView() {
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        
        self.favoritesTableView.tableFooterView = UIView(frame: .zero)
        
        self.favoritesTableView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellReuseIdentifier: "FavoritesCell")
        self.favoritesTableView.register(UINib(nibName: "ErrorAndEmptyCell", bundle: nil), forCellReuseIdentifier: "ErrorAndEmptyCell")
        self.favoritesTableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    }
    
    
    // MARK: viewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
        self.controller.delegate = self
        self.controller.didUpdateFavorites()
    }
    
    
    // MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetailVC", let _recipe: Recipe = sender as? Recipe {
            let vc: RecipeDetailVC? = segue.destination as? RecipeDetailVC
            vc?.receita = _recipe
        }
    }
    
    
    // MARK: Delegate Methods
    func didUpdate() {
        self.favoritesTableView.reloadData()
    }
}


// MARK: extension TableView
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.controller.state {
        case .loaded:
            let cell:FavoritesCell? = self.favoritesTableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesCell
            cell?.setup(recipe: self.controller.favoriteRecipeAt(index: indexPath.row))
            return cell ?? UITableViewCell()
        case .loading:
            let cell:LoadingCell? = self.favoritesTableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell
            cell?.setupLoading()
            return cell ?? UITableViewCell()
        case .error:
            let cell:ErrorAndEmptyCell? = self.favoritesTableView.dequeueReusableCell(withIdentifier: "ErrorAndEmptyCell", for: indexPath) as? ErrorAndEmptyCell
            cell?.setupError()
            return cell ?? UITableViewCell()
        case .empty:
            let cell:ErrorAndEmptyCell? = self.favoritesTableView.dequeueReusableCell(withIdentifier: "ErrorAndEmptyCell", for: indexPath) as? ErrorAndEmptyCell
            cell?.setupEmpty()
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.controller.removeFavoriteAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _recipe: Recipe = self.controller.favoriteRecipeAt(index: indexPath.row) {
            self.performSegue(withIdentifier: "RecipeDetailVC", sender: _recipe)
        }
    }
}
