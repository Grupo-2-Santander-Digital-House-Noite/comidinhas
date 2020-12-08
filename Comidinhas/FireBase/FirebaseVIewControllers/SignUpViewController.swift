//
//  SignUpViewController.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 01/12/20.
//

import UIKit


class SignUpViewController: UIViewController {

    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetError()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        self.resetError()
        if !self.validate() {
            return
        }
        
        if let _name = fullnameTextField.text,
           let _email = emailTextField.text,
           let _password = passwordTextField.text {
            
            let user = User(name: _name, email: _email)
            AppUserManager.shared.create(user: user, withPassword: _password) {
                self.dismissSelf()
            } failure: { (error) in
                self.displayError(message: error.localizedDescription)
            }
            
        } else {
            self.displayError(message: "Could not get user info")
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
        if !self.fullnameTextField.hasText || !self.emailTextField.hasText || !self.passwordTextField.hasText || !self.confirmPasswordTextfield.hasText {
            self.displayError(message: "All fields are required!")
            return false
        }
        
        if self.passwordTextField.text != self.confirmPasswordTextfield.text {
            self.displayError(message: "Passwords don't match!")
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
