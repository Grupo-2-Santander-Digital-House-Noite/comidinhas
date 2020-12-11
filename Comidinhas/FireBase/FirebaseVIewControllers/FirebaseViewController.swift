//
//  FirebaseViewController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 01/12/20.
//

import UIKit

class FirebaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppUserManager.shared.hasLoggedUser() {
            self.dismissSelf()
        }
    }
    
    
    func dismissSelf() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ResetPasswordViewController", sender: nil)
    }
    
}
