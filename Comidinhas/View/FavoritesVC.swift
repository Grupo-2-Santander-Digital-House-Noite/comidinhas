//
//  FavoritesVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func searchBarButtonClick(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController: SearchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        newViewController.modalPresentationStyle = .overFullScreen
        newViewController.delegate = self
        self.present(newViewController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavoritesVC: SearchVCDelegate {
    func returnTabBar() {
        self.tabBarController?.selectedIndex = 0
    }
}
