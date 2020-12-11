//
//  SignInVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 01/12/20.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

protocol SignUpVCDelegate: class {
    func hideViewSignUp() 
}

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    weak var delegate:SignUpVCDelegate?
    
    
    // MARK: configView
    
    private func configView() {
        self.signUpButton.layer.cornerRadius = 5
        self.errorLabel.alpha = 0
    }

    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: private funcs
    
    // Checa os fields e valida se os dados estão corretos
    // Tudo correto -> retorna nil
    // Algo erro -> retorna mensagem de erro
    private func validateFields() -> String? {
        // checa se todos os campos estão preenchidos
        if self.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please, fill in all fields"
        }
        return nil // se tudo estiver certo
    }
    
    // Mostra mensagem de erro, se ocorrer erro na validação dos campos
    private func showError(_ message:String) {
        self.errorLabel.text = message
        self.errorLabel.alpha = 1
    }
    
    
    // MARK: IBAction
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        // Valida os campos
        let error = self.validateFields()
        if error != nil {
            // Tem alguma coisa errada com os campos -> mostrar mensagem de erro
            self.showError(error ?? "")
        } else {
            // Cria versões clean dos dados
            let fullname = self.nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Cria um user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                // Chega se há erro
                if error != nil {
                    // Tem erro ao criar o usuário
                    self.showError("Error creating user")
                } else {
                    // User criado com sucesso -> guardar o nome completo no Firestore
                    let db = Firestore.firestore() // guarda os dados no DB do Firebase
                    // result!.user.uid = uid criado randomicamente na autenticação, não é o nome do document (que também é gerado randomicamente
                    db.collection("users").addDocument(data: ["fullname":fullname, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            // Ocorreu erro nao referencial os dados no Firebase
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transitar para a homescreen
                    let alert = UIAlertController(title: "Success", message: "Your accont was created", preferredStyle: .alert)
                    let buttonOK = UIAlertAction(title: "OK", style: .default) { (success) in
                        // Logar o usuário
                        Auth.auth().signIn(withEmail: email, password: password) { (reuslt, error) in
                            if error != nil {
                                self.showError("Couldn't sign in. Try again latter")
                            } else {
                                userLoggedIn = true
                                self.delegate?.hideViewSignUp()
                            }
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                        self.tabBarController?.selectedIndex = 0
                    }
                    alert.addAction(buttonOK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
