//
//  SettingCadVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

class SettingsCadVC: UIViewController {

    @IBOutlet weak var editFullName: UITextField!{
        didSet{
            editFullName.tintColor = UIColor.lightGray
            editFullName.setIcon(#imageLiteral(resourceName: "user"))
        }
    }
    @IBOutlet weak var editEmail: UITextField!{
        didSet{
            editEmail.tintColor = UIColor.lightGray
            editEmail.setIcon(#imageLiteral(resourceName: "email"))
        }
    }
    @IBOutlet weak var editPassword: UITextField!{
        didSet {
              editPassword.tintColor = UIColor.lightGray
              editPassword.setIcon(#imageLiteral(resourceName: "password"))
           }
    }
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
     
    }

    
    // MARK: VALIDACAO DO CAMPO EMAIL
    
    func isValidEmail(email: String) -> Bool{

        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        
        return emailTest.evaluate(with: email)
       

    }
    
    func validField(){
        
        let emailConf = self.isValidEmail(email: self.editEmail.text!)
        
        if self.editFullName.text?.isEmpty == true {
            self.editFullName.layer.borderColor = UIColor.red.cgColor
            self.editFullName.layer.borderWidth = 1.0
            self.editFullName.attributedPlaceholder = NSAttributedString(string: "Full name - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editFullName.text?.isEmpty == false {
            self.editFullName.layer.borderWidth = 0
        }
        if emailConf == false || self.editEmail.text?.isEmpty == true {
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
        
        if emailConf == true && self.editFullName.text?.isEmpty == false && self.editEmail.text?.isEmpty == false && self.editPassword.text?.isEmpty == false {
            let alert = UIAlertController(title: "Success", message: "Your account was created", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                self.performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
            
        }else if emailConf == false || self.editFullName.text?.isEmpty == true || self.editEmail.text?.isEmpty == true || self.editPassword.text?.isEmpty == true {
            let alert = UIAlertController(title: "Please", message: "Check the fiels entered", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in
                
            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    @IBAction func bntCreateAcc(_ sender: UIButton) {
        self.validField()
        
        // VALIDACAO DO CAMPO SENHA
   
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
extension UITextField{
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}
