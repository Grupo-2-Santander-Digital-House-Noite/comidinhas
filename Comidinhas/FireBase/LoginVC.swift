//
//  LoginVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 21/10/20.
//

import UIKit
import FirebaseAuth

protocol LoginVCDelegate: class {
    func hideViewLogin()
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate:LoginVCDelegate?
    
    
    // MARK: configview
    
    private func configView() {
        self.loginButton.layer.cornerRadius = 5
        self.errorLabel.alpha = 0
    }
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configView()
    }
    
    
    // MARK: private funcs
    
    // mesmo método que em SignUpVC
    private func validateFields() -> String? {
        if self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please, fill in all fields"
        }
        return nil
    }
    
    private func showError(_ message:String) {
        self.errorLabel.text = message
        self.errorLabel.alpha = 1
    }
    
    
    // MARK: IBAction
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        // Validar textFields
        let error = self.validateFields()
        if error != nil {
            // Tem alguma coisa errada com os campos -> mostrar mensagem de erro
            self.showError(error!)
        } else {
            // Criando versões clean dos dados
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Logar o usuário
            Auth.auth().signIn(withEmail: email, password: password) { (resut, error) in
                if error != nil {
                    // Houve alguma erro ao tentar logar
                    self.showError("Couldn't sign in. Try againd latter")
                } else {
                    userLoggedIn = true
                    self.delegate?.hideViewLogin()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
}
