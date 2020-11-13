//
//  SettingCadVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

class SettingsCadVC: UIViewController {

    @IBOutlet weak var editFullName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    
    
    @IBOutlet weak var bntCreateAcc: UIButton!
    
    fileprivate func configButton() {
        self.bntCreateAcc.layer.cornerRadius = 5
    }
    
    fileprivate func configTextField() {
        self.editFullName.delegate = self
        self.editEmail.delegate = self
        self.editPassword.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTextField()
        self.configButton()
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func bntCreateAcc(_ sender: UIButton) {
        
        // VALIDACAO DO CAMPO EMAIL
        if self.editFullName.text?.isEmpty == true {
            self.editFullName.layer.borderColor = UIColor.red.cgColor
            self.editFullName.layer.borderWidth = 1.0
            self.editFullName.attributedPlaceholder = NSAttributedString(string: "Full name - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editFullName.text?.isEmpty == false {
            self.editFullName.layer.borderWidth = 0
        }
        
        // VALIDACAO DO CAMPO SENHA
        if self.editEmail.text?.isEmpty == true {
            self.editEmail.layer.borderColor = UIColor.red.cgColor
            self.editEmail.layer.borderWidth = 1.0
            self.editEmail.attributedPlaceholder = NSAttributedString(string: "E-mail - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmail.text?.isEmpty == false {
            self.editEmail.layer.borderWidth = 0
        }
        
        
        if self.editPassword.text?.isEmpty == true {
            self.editPassword.layer.borderColor = UIColor.red.cgColor
            self.editPassword.layer.borderWidth = 1.0
            self.editPassword.attributedPlaceholder = NSAttributedString(string: "Password - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPassword.text?.isEmpty == false {
            self.editPassword.layer.borderWidth = 0
        }
        
        
        if self.editFullName.text?.isEmpty == false && self.editEmail.text?.isEmpty == false && self.editPassword.text?.isEmpty == false {
            let alert = UIAlertController(title: "Success", message: "Your account was created", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                self.performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
extension SettingsCadVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editFullName:
            self.editEmail.becomeFirstResponder()
        case self.editEmail:
            self.editPassword.becomeFirstResponder()
        default:
            self.editPassword.resignFirstResponder()
        }
        return true
    }
    
}
