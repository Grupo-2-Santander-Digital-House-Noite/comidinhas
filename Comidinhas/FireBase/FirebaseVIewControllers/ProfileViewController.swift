//
//  ProfileViewController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 01/12/20.
//

import UIKit

class ProfileViewController: UIViewController {

    private let FIREBASE_SEGUE:String = "FirebaseViewController"
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !AppUserManager.shared.hasLoggedUser() {
            self.performSegue(withIdentifier: self.FIREBASE_SEGUE, sender: nil)
        } else {
            self.resetError()
            self.setupWithUser()
        }
        
    }
    
    func setupWithUser() {
        guard let user = AppUserManager.shared.loggedUser else {
            self.displayError(message: "User not found!")
            return
        }
        
        self.nomeLabel.text = user.name ?? "N/A"
        self.emailLabel.text = user.email ?? "N/A"
    }
    
    func resetError() {
        self.errorLabel.alpha = 0
        self.errorLabel.text = ""
    }
    
    func displayError(message: String) {
        self.errorLabel.alpha = 1
        self.errorLabel.text = message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Não precisa fazer nada por enquanto.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        AppUserManager.shared.logout {
            if !AppUserManager.shared.hasLoggedUser() {
                self.performSegue(withIdentifier: self.FIREBASE_SEGUE, sender: nil)
            }
        } failure: { (error) in
            self.displayError(message: error.localizedDescription)
        }
        
    }
    

}
