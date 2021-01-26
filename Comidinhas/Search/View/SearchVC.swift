//
//  SearchVC.swift
//  Comidinhas
//
//  Created by Lucas Santiago on 04/11/20.
//

import UIKit


protocol SearchVCDelegate: AnyObject {
    func returnTabBar(filter: [RecipeFilter])
    
}


class SearchVC: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    weak var delegate: SearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.reloadData()
        // Do any additional setup after loading the view.
    }
}


// MARK: extension TableViewDelegate
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}


// MARK: extension TableViewDataSource
extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //switch indexPath.row {
        //case 1:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
}


// MARK: extension SearchTableViewDelegate
extension SearchVC:  SearchTableViewCellDelegate {
    func findClick(filter: [RecipeFilter]) {
        self.dismiss(animated: true)
        delegate?.returnTabBar(filter: filter)
    }
}
