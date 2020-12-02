//
//  SignInViewController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 01/12/20.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetError()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        if !self.validate() {
            return
        }
        
        if let _email = self.emailTextField.text,
           let _password = self.passwordTextField.text {
            AppUserManager.shared.attemptLoginWith(email: _email, usingPassword: _password) {
                self.dismissSelf()
            } failure: { (error) in
                self.displayError(message: error.localizedDescription)
            }

        }
    }
    
    func dismissSelf() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func validate() -> Bool {
        if !self.emailTextField.hasText || !self.passwordTextField.hasText {
            self.displayError(message: "All fields are required!")
            return false
        }
        return true
    }
    
    func resetError() {
        self.errorLabel.alpha = 0
        self.errorLabel.text = ""
    }
    
    func displayError(message: String) {
        self.errorLabel.alpha = 1
        self.errorLabel.text = message
    }
    
    

}
