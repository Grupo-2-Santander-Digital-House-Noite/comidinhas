//
//  ShoppingListVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class ShoppingListVC: UIViewController, ShoppingListDelegate {

    @IBOutlet weak var shoppingListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.view.backgroundColor = UIColor(red: 1, green: 0.8509803922, blue: 0.5921568627, alpha: 1)
        
        ShoppingList.shared.subscribe(delegate: self)
        
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
    
    
    @IBAction func adiciona(_ sender: UIButton) {
        print("Adiciona")
        let ingredientData: [String: String] = [
            "Morango" : "Bandeja(s)",
            "Uva" : "Bandeja(s)",
            "Ovos" : "Unidade(s)",
            "Banana" : "Unidade(s)",
            "Laranja" : "Unidade(s)",
            "Farinha" : "Gramas",
            "Fermento" : "Gramas",
            "Açucar" : "Gramas",
            "Suco de limão" : "mls",
            "Água" : "mls",
            "Azeite" : "mls"]
        let ranges : [String: ClosedRange<Int>] = [
            "Bandeja(s)": 1...3,
            "Unidade(s)": 1...10,
            "Gramas": 100...600,
            "mls": 10...1000
        ]
        let randomKey = ingredientData.keys.randomElement();
        let randomUnity : String = ingredientData[randomKey ?? "Desconhecido"] ?? "N/D"
        let randomQuantity = Int.random(in: ranges[randomUnity] ?? 1...3)
        
        ShoppingList.shared.add(ingredient: IngredientEntry(named: randomKey ?? "Desconhecido", withAmount: Double(randomQuantity), andMeasureUnity: randomUnity))
        updateTableView()
    }
    
    @IBAction func limpa(_ sender: UIButton) {
        print("Limpa")
        ShoppingList.shared.clear()
        updateTableView()
    }
    
    private func updateTableView() {
        self.shoppingListTableView.reloadData()
    }
    
    // MARK: REACT WHEN SHOPPING LIST IS UPDATED
    func didAdd(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        self.updateTableView()
    }
    
    func didRemove(_ shoppingList: ShoppingList, ingredient: IngredientEntry) {
        self.updateTableView()
    }
}

extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingList.shared.getAll().count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ShoppingList.shared.getAll().count == 0 {
            return 1
        }
        
        return section == 0 ? ShoppingList.shared.getDesmarcados().count : ShoppingList.shared.getMarcados().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ShoppingList.shared.getAll().count == 0 {
            let emptyCell: EmptyShoppingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmptyShoppingListTableViewCell", for: indexPath) as? EmptyShoppingListTableViewCell ?? EmptyShoppingListTableViewCell()
            return emptyCell
        }
        
        let shoppingItemCell: ShoppingListItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItemTableViewCell", for: indexPath) as? ShoppingListItemTableViewCell ?? ShoppingListItemTableViewCell()
        let collection: [IngredientEntry] = indexPath.section == 0 ? ShoppingList.shared.getDesmarcados() : ShoppingList.shared.getMarcados()
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
