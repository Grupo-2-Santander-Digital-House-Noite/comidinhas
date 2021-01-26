//
//  RecipesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipesVC: BaseViewController {

    @IBOutlet weak var recipesListTableView: UITableView!
    @IBOutlet weak var serachBarButton: UIBarButtonItem!
    
    weak var delegate: SearchVCDelegate?
    private var controller = RecipesWebService.shared
    
    
    // MARK: configTableView
    private func configTableView() {
        recipesListTableView.dataSource = self
        recipesListTableView.delegate = self
        
        self.recipesListTableView.tableFooterView = UIView(frame: .zero)
        
        self.recipesListTableView.register(UINib(nibName: "RecipesCell", bundle: nil), forCellReuseIdentifier: "RecipesCell")
        self.recipesListTableView.register(UINib(nibName: "NoRecipeCell", bundle: nil), forCellReuseIdentifier: "NoRecipeCell")
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        // Do any additional setup after loading the view.
        self.showLoadingCooker()
        
        var url: String = ""
        url = "https://api.spoonacular.com/recipes/complexSearch?"
        self.controller.loadRecipesListWithUrl(url: url, completionHandler: { (result, error) in
            if result {
                DispatchQueue.main.async {
                    self.hideLoadingCooker()
                    self.recipesListTableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.hideLoadingCooker()
                    print("deu error: \(error)")
                }
            }
        })
    }
    
    
    // MARK: IBAction serachBarButtonClick
    @IBAction func searchBarButtonClick(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController: SearchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        newViewController.modalPresentationStyle = .automatic
        newViewController.delegate = self
        self.present(newViewController, animated: true, completion: nil)
    }
}


// MARK: extension TableView
extension RecipesVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RecipesWebService.shared.recipes.count != 0 {
            return RecipesWebService.shared.recipes.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if RecipesWebService.shared.recipes.count != 0 {
            let cell:RecipesCell? = self.recipesListTableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipesCell
            cell?.setup(receita: RecipesWebService.shared.recipes[indexPath.row])
            return cell ?? UITableViewCell()
        } else {
            let cell:NoRecipeCell? = self.recipesListTableView.dequeueReusableCell(withIdentifier: "NoRecipeCell", for: indexPath) as? NoRecipeCell
            return cell ?? UITableViewCell()
        }
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


// MARK: extension: UIScrollViewDelegate
extension RecipesVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard controller.finishedRequest else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if RecipesWebService.shared.recipes.count != 0 {
            
                var url: String = ""
            
                if RecipesWebService.shared.lastFilter.count == 0 {
                    url = "https://api.spoonacular.com/recipes/complexSearch?"
                } else {
                    url = "https://api.spoonacular.com/recipes/complexSearch"
                    var components: [String] = []
                    for _filter in RecipesWebService.shared.lastFilter {
                        components.append("\(_filter.name)=\(_filter.value)")
                    }
                    url = "\(url)?\(components.joined(separator: "&"))"
                }

                self.controller.loadRecipesListWithUrlNewResults(url: url, offset: RecipesWebService.shared.recipes.count, completionHandler: { (result, error) in

                    if result {

                        DispatchQueue.main.async {
                            self.recipesListTableView.reloadData()
                        }

                    } else {

                        DispatchQueue.main.async {
                            print("deu error: \(error)")
                        }
                    }
                })
            }
        }
    }
}


// MARK: extension SearchVCDelegate
extension RecipesVC: SearchVCDelegate {
    func returnTabBar(filter: [RecipeFilter]) {
        var url: String = ""
        if filter.count == 0 {
            url = "Utilize a tela de filtro para montar uma url"
        } else {
            RecipesWebService.shared.lastFilter = filter
            url = "https://api.spoonacular.com/recipes/complexSearch"
            var components: [String] = []
            for _filter in filter {
                components.append("\(_filter.name)=\(_filter.value)")
            }
            url = "\(url)?\(components.joined(separator: "&"))"
        }
        
        self.controller.loadRecipesListWithUrl(url: url, completionHandler: { (result, error) in

            if result {
                    
                DispatchQueue.main.async {
                    self.recipesListTableView.reloadData()
                }
                    
            } else {
                    
                DispatchQueue.main.async {
                    print("deu error: \(error)")
                }
            }
        })
    }
}
