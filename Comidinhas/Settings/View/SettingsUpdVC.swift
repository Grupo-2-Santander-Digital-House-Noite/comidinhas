//
//  SettingsCadVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

class SettingsUpdVC: UIViewController {
    
    @IBOutlet weak var editFullName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editRepeatPassword: UITextField!
    
    @IBOutlet weak var bntUpdate: UIButton!
    @IBOutlet weak var bntLogout: UIButton!
    
    let controller = Settings()
    
    fileprivate func configTextField() {
        
        self.editFullName.delegate = self
        self.editEmail.delegate = self
        self.editPassword.delegate = self
        self.editRepeatPassword.delegate = self
        
    }
    
    fileprivate func configBnt() {
        self.bntUpdate.layer.cornerRadius = 5
        self.bntLogout.layer.cornerRadius = 5
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTextField()
        self.configBnt()
        
    }
    func validField(){
        let emailConf = controller.isValidEmail(email: self.editEmail.text!)
        
        //name vazio
        if self.editFullName.text?.isEmpty == true {
            self.editFullName.layer.borderColor = UIColor.red.cgColor
            self.editFullName.layer.borderWidth = 1.0
            self.editFullName.attributedPlaceholder = NSAttributedString(string: "Full name - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editFullName.text?.isEmpty == false {
            self.editFullName.layer.borderWidth = 0
        }
        //email vazio
        if emailConf == false || self.editEmail.text?.isEmpty == true {
            self.editEmail.layer.borderColor = UIColor.red.cgColor
            self.editEmail.layer.borderWidth = 1.0
            self.editEmail.attributedPlaceholder = NSAttributedString(string: "E-mail - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmail.text?.isEmpty == false {
            self.editEmail.layer.borderWidth = 0
        }
        //senha vazia
        if self.editPassword.text?.isEmpty == true   {
            self.editPassword.layer.borderColor = UIColor.red.cgColor
            self.editPassword.layer.borderWidth = 1.0
            self.editPassword.attributedPlaceholder = NSAttributedString(string: "Password - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPassword.text?.isEmpty == false {
            self.editPassword.layer.borderWidth = 0
        }
        //senha repet vazia
        if self.editRepeatPassword.text?.isEmpty == true {
            self.editRepeatPassword.layer.borderColor = UIColor.red.cgColor
            self.editRepeatPassword.layer.borderWidth = 1.0
            self.editRepeatPassword.attributedPlaceholder = NSAttributedString(string: "Password - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
        }else if  self.editPassword != editRepeatPassword {
        }else if self.editRepeatPassword.text?.isEmpty == false {
            self.editRepeatPassword.layer.borderWidth = 0
            
        }
        //email  nome senha repete ok
        if emailConf == true && self.editFullName.text?.isEmpty == false && self.editEmail.text?.isEmpty == false && self.editPassword.text?.isEmpty == false && self.editRepeatPassword.text?.isEmpty == false
        {
            let alert = UIAlertController(title: "Success", message: "Changed data ", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                self.performSegue(withIdentifier: "changedData", sender: nil)
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
            
            // campos vazios
        }else if emailConf == false || self.editFullName.text?.isEmpty == true || self.editEmail.text?.isEmpty == true || self.editPassword.text?.isEmpty == true || self.editRepeatPassword.text?.isEmpty == true {
            
            let alert = UIAlertController(title: "Please", message: "Check the fiels entered", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default)
            {(success) in
                
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func bntUpdate(_ sender: UIButton) {
        self.validField()
    }
}
extension SettingsUpdVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editFullName:
            self.editEmail.becomeFirstResponder()
        case self.editEmail:
            self.editPassword.becomeFirstResponder()
        case self.editPassword:
            self.editRepeatPassword.becomeFirstResponder()
        default:
            self.editRepeatPassword.resignFirstResponder()
        }
        return true
    }
    
}
