//
//  ResetPasswordViewController.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 09/12/20.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.enviarButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enviarButtonTapped(_ sender: UIButton) {
        self.showLoadingCooker()
        AppUserManager.shared.resetPassword(email: self.emailTextField.text ?? "") {
            self.hideLoadingCooker()
            let alert = UIAlertController(title: "Success", message: "Please, check your email to reset your password", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                self.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        } failure: { (error) in
            self.hideLoadingCooker()
            self.displayErrorAlertWith(title: "OPS!", message: "There is something wrong. Please enter a valid email", completion: nil)
            print(error.localizedDescription)
        }
    }
}
