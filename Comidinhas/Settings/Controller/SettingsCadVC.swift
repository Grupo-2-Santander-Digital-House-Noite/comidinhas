//
//  SettingCadVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

protocol SettingsCadVCDelegate: class {
    func hideViewFromSignUp()
}

class SettingsCadVC: BaseViewController {
    
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

    let controller = Settings()
    weak var didLoginDelegate: DidLoginDelegate?
    weak var delegate:SettingsCadVCDelegate?
    

    fileprivate func configButton() {
        controller.confButton(button: self.bntCreateAcc)
    }
    
    fileprivate func configTextField() {
        self.editFullName.delegate = self
        self.editEmail.delegate = self
        self.editPassword.delegate = self
    }

    let bnt = UIButton(type: .custom)
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTextField()
        self.configButton()
        
        bnt.setImage(UIImage(named: "eyeclosed30"), for: .normal)
        bnt.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        bnt.addTarget(self, action: #selector(self.bntPasswordShow), for: .touchUpInside)
        editPassword.rightView = bnt
        editPassword.rightViewMode = .always
        editPassword.isSecureTextEntry = true
    }

    
    // MARK: - validField()
    func validField(){
        let emailConf = controller.isValidEmail(email: self.editEmail.text!)
        let cleanedPassword = editPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.editFullName.text?.isEmpty == true {
            self.editFullName.placeholder = "Full Name - Required"
            controller.setupTF(textField: editFullName)

        } else if self.editFullName.text?.isEmpty == false {
            self.editFullName.layer.borderWidth = 0
        }
        
        if self.editPassword.text?.isEmpty == false {
            self.editPassword.layer.borderWidth = 0
            self.editPassword.isHidden = false
            } else {
                self.editPassword.placeholder = "Password - Required"
                controller.setupTF(textField: editPassword)
            
            }
        if self.editEmail.text?.isEmpty == true {
            self.editEmail.placeholder = "E-mail - Required"
            controller.setupTF(textField: editEmail)
            return
        } else if self.editEmail.text?.isEmpty == false {
            self.editEmail.layer.borderWidth = 0
        }
        //VALIDACAO DO CAMPO EMAIL
        if emailConf == true && self.editEmail.text?.isEmpty == false {
            self.editEmail.isHidden = false
        } else {
          self.editEmail.placeholder = "E-mail - Syntax Incorrect"
            controller.setupTF(textField: editEmail)
        }
      
        if emailConf == false || self.editFullName.text?.isEmpty == true || self.editEmail.text?.isEmpty == true || self.editPassword.text?.isEmpty == true {
            let alert = UIAlertController(title: "Please", message: "Check the fiels entered", preferredStyle: .alert)
            let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in

            }
            alert.addAction(buttonOK)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    // MARK: - IBAction
    @IBAction func bntCreateAcc(_ sender: Any) {
        self.validField()
        
        guard let name = self.editFullName.text else {
            self.displayErrorAlertWith(title: "Error", message: "Oops, we are unable to see your name, are you sure it is there?", completion: nil)
            return
        }
        
        guard let email = self.editEmail.text else {
            self.displayErrorAlertWith(title: "Error", message: "Well, we need an e-mail address to register you, can you help us help you?", completion: nil)
            return
        }
        
        guard let password = self.editPassword.text else {
            self.displayErrorAlertWith(title: "Error", message: "Are you sure you do not need a password, we believe you do!", completion: nil)
            return
        }
        
        let userToBeCreated: User = User(name: name, email: email)
        self.view.endEditing(true)
        self.showLoadingCooker()
        
        AppUserManager.shared.create(user: userToBeCreated, withPassword: password) {
            self.displayErrorAlertWith(title: "Well done", message: "your account was created, now you can mark recipes as favorites and write reviews.", dismissTitle: "Let's go",completion: nil, dismissAction: { _ in
                self.hideLoadingCooker()
                self.didLoginDelegate?.handleDidLogin()
                self.navigationController?.popToRootViewController(animated: true)
                self.delegate?.hideViewFromSignUp()
            })
        } failure: { (error) in
            self.hideLoadingCooker()
            self.displayErrorAlertWith(title: "error", message: error.localizedDescription, completion: nil)
        }
    }
    
    @IBAction func bntPasswordShow(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if ( sender as! UIButton).isSelected {
            self.editPassword.isSecureTextEntry = false
            bnt.setImage(UIImage(named: "eyeopen30"), for: .normal)
        } else {
            self.editPassword.isSecureTextEntry = true
            bnt.setImage(UIImage(named: "eyeclosed30"), for: .normal)
        }
    }
}


// MARK: - extension TextFieldDelegate
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


// MARK: - extension UITextField
extension UITextField {
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



