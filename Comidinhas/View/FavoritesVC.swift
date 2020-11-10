//
//  FavoritesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class FavoritesVC: UIViewController {
    
    
    // MARK: IBoutlet
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var arrayFavorites:[Favorites] = [Favorites(nomeReceita: "Chocolate Cake", imagemReceita: "ChocolateCake"),
                                      Favorites(nomeReceita: "Hamburger", imagemReceita: "Hamburger"),
                                      Favorites(nomeReceita: "Tomato Soup", imagemReceita: "TomatoSoup"),
                                      Favorites(nomeReceita: "Meat Pastel", imagemReceita: "MeatPastel"),
                                      Favorites(nomeReceita: "Rainbow Cake", imagemReceita: "RainbowCake"),
                                      Favorites(nomeReceita: "Grilled Fish", imagemReceita: "GrilledFish"),
                                      Favorites(nomeReceita: "Chicken Strogonoff", imagemReceita: "ChickenStrogonoff")]

    
    // MARK: configuação TableView
    
    private func configTableView() {
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        
        self.favoritesTableView.tableFooterView = UIView(frame: .zero)
        
        self.favoritesTableView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellReuseIdentifier: "FavoritesCell")
    }
    
    
    // MARK: viewdidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
        // Do any additional setup after loading the view.
    }

}


// MARK: extension

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFavorites.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoritesCell? = self.favoritesTableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesCell
        
        cell?.setup(favorites: self.arrayFavorites[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.arrayFavorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    
}
