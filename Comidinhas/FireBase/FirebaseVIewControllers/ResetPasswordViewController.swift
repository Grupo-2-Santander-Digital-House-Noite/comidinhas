//
//  ResetPasswordViewController.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 09/12/20.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enviarButtonTapped(_ sender: UIButton) {
        AppUserManager.shared.resetPassword(email: self.emailTextField.text ?? "") {
            let alert = UIAlertController(title: "Success", message: "Please, check your email to reset your password", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 0
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        } failure: { (error) in
            print(error.localizedDescription)
        }
    }
}
