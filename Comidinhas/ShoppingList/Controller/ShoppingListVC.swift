//
//  ShoppingListVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class ShoppingListVC: UIViewController, ShoppingListDelegate {

    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var shoppingListClearButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.view.backgroundColor = ColorConstants.BACKGROUND_COLOR
        
        ShoppingList.shared.subscribe(delegate: self)
        updateView()
    }
    
    private func setupTableView() {
        self.shoppingListTableView.delegate = self
        self.shoppingListTableView.dataSource = self
        self.shoppingListTableView.rowHeight = UITableView.automaticDimension
        
        self.shoppingListTableView.register(UINib(nibName: "ShoppingListItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListItemTableViewCell")
        self.shoppingListTableView.register(UINib(nibName: "EmptyShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyShoppingListTableViewCell")
        
        self.shoppingListTableView.backgroundColor = .none
        self.shoppingListTableView.backgroundView = .none
        self.shoppingListTableView.separatorStyle = .none
    }
    
    
    // MARK: - IBAction limpaLista
    @IBAction func limpaLista(_ sender: UIBarButtonItem) {
        self.displayConfirmationAlert(title: "Are you sure?", message: "Are you sure that you want to delete your shopping list? There is no coming back!", confirmTitle: "Ok", cancelTitle: "Cancel") { (action) in
            ShoppingList.shared.clear()
            self.updateView()
        }
    }
    
    
    private func updateView() {
        self.updateClearButton()
        self.shoppingListTableView.reloadData()
    }
    
    private func updateClearButton() {
        if ShoppingList.shared.getAll().count == 0 {
            self.shoppingListClearButton.isEnabled = false
            self.shoppingListClearButton.tintColor = .clear
        } else {
            self.shoppingListClearButton.isEnabled = true
            self.shoppingListClearButton.tintColor = ColorConstants.RED_COLOR
        }
    }
    
    
    // MARK: REACT WHEN SHOPPING LIST IS UPDATED
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        self.updateView()
    }
    
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        self.updateView()
    }
    
    @IBAction func tappedSettingsTestButton(_ sender: UIButton) {
        performSegue(withIdentifier: "EntrarVC", sender: nil)
    }
}


// MARK: - extension TableView
extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell: ShoppingListItemTableViewCell? = tableView.cellForRow(at: indexPath) as? ShoppingListItemTableViewCell
            if let ingredient = cell?.ingredientEntry {
                ShoppingList.shared.remove(ingredient: ingredient)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ShoppingList.shared.getAll().count == 0 {
            return 1
        }
        
        return ShoppingList.shared.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ShoppingList.shared.getAll().count == 0 {
            let emptyCell: EmptyShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmptyShoppingListTableViewCell", for: indexPath) as? EmptyShoppingListTableViewCell ?? EmptyShoppingListTableViewCell()
            return emptyCell
        }
        
        let shoppingItemCell: ShoppingListItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemTableViewCell", for: indexPath) as? ShoppingListItemTableViewCell ?? ShoppingListItemTableViewCell()
        let collection: [IngredientEntry] = ShoppingList.shared.getAll()
        shoppingItemCell.setupWith(ingredient: collection[indexPath.row])
        return shoppingItemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: ShoppingListItemTableViewCell = tableView.cellForRow(at: indexPath) as? ShoppingListItemTableViewCell {
            cell.toggle()
            cell.selectionStyle = .none
            tableView.reloadData()
        }
    }
}
