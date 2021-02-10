//
//  SettingsViewControler.swift
//  Comidinhas
//
//  Created by Cátia Souza on 06/02/21.
//

import Foundation
import UIKit

class SettingsViewControler: BaseViewController {
    
    let controler = Settings()
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var bntCancel: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var dataChangeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var bntLogin: UIButton!
    
    @IBOutlet weak var bntSignup: UIButton!
    
    @IBOutlet weak var btnFullnameChange: UIButton!
    @IBOutlet weak var btnEmailChange: UIButton!
    @IBOutlet weak var btnPasswordChange: UIButton!
    
    @IBOutlet weak var viewYourData: UIView!
    @IBOutlet weak var viewlogin: UIView!
    
    var email = ""{
        didSet{
            self.setupEmail()
        }
    }
    var name = ""{
        didSet {
            self.setupName()
        }
    }
    var password = "" {
        didSet {
            self.setupPassword()
        }
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTextField()
        self.configView()
        self.btnEmailChange.isEnabled = true
        dataChangeTextField.translatesAutoresizingMaskIntoConstraints = false
        self.btnEmailChange.isEnabled = true 
    }
    
    // MARK: CONFIGURACAO GERAL DOS TEXTFIELDS
    fileprivate func configTextField() {
        self.dataChangeTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
    }
    
    func setupEmail() {
        //dois DispatchQueue.main.async?? incognita
        DispatchQueue.main.async {
            self.hideTextFields()
            DispatchQueue.main.async {
                self.dataChangeTextField.isHidden = false
                self.passwordTextField.isHidden = false
                self.btnEmailChange.isHidden = false
                self.bntCancel.isHidden = false
                self.dataChangeTextField.isSecureTextEntry = false
                self.dataChangeTextField.placeholder = "Change email"
                self.dataChangeTextField.text = ""
                self.passwordTextField.placeholder = "Confirm with your password"
                self.passwordTextField.text = ""
                self.dataChangeTextField.becomeFirstResponder()
            }
        }
    }
    
    func setupName() {
        DispatchQueue.main.async {
            self.hideTextFields()
            DispatchQueue.main.async {
                self.dataChangeTextField.isHidden = false
                self.btnFullnameChange.isHidden = false
                self.bntCancel.isHidden = false
                self.dataChangeTextField.isSecureTextEntry = false
                self.dataChangeTextField.placeholder = "Change fullname"
                self.dataChangeTextField.text = ""
                self.dataChangeTextField.becomeFirstResponder()
            }
        }
    }
    
    func setupPassword(){
        self.hideTextFields()
        DispatchQueue.main.async {
            self.dataChangeTextField.isHidden = false
            self.passwordTextField.isHidden = false
            self.repeatPasswordTextField.isHidden = false
            self.btnPasswordChange.isHidden = false
            self.bntCancel.isHidden = false
            self.dataChangeTextField.isSecureTextEntry = true
            self.dataChangeTextField.placeholder = "Currente password"
            self.dataChangeTextField.text = ""
            self.passwordTextField.placeholder = "New password"
            self.passwordTextField.text = ""
            self.repeatPasswordTextField.placeholder = "Repeat new password"
            self.repeatPasswordTextField.text = ""
            self.dataChangeTextField.becomeFirstResponder()
        }
    }
    
    // MARK: CONFIGURACAO GERAL DOS BOTOES
    fileprivate func configView() {
        controler.confButton(button: bntLogin)
        controler.confButton(button: bntCancel)
        controler.confButton(button: btnLogout)
        controler.confButton(button: bntSignup)
        
        self.errorMessageLabel.alpha = 0
        if !AppUserManager.shared.hasLoggedUser() {
            self.viewYourData.isHidden = true
            self.viewlogin.isHidden = false
        } else {
            self.viewYourData.isHidden = false
            self.viewlogin.isHidden = true
            self.hideTextFields()
            self.fullNameLabel.text = AppUserManager.shared.loggedUser?.name
            self.emailLabel.text = AppUserManager.shared.loggedUser?.email
        }
    }
    
    // MARK: private func
    private func showError(message:String) {
        self.errorMessageLabel.text = message
        self.errorMessageLabel.alpha = 1
    }
    
    private func resetError() {
        self.errorMessageLabel.text = ""
        self.errorMessageLabel.alpha = 0
    }
    
    private func hideTextFields() {
        self.dataChangeTextField.isHidden = true
        self.passwordTextField.isHidden = true
        self.repeatPasswordTextField.isHidden = true
        self.btnFullnameChange.isHidden = true
        self.btnEmailChange.isHidden = true
        self.btnPasswordChange.isHidden = true
        self.bntCancel.isHidden = true
        self.resetError()
    }
    
    // MARK: IBAction
    @IBAction func btnSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingsCadVC", sender: nil)
       
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingsAuthVC", sender: nil)
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton) {
        self.showLoadingCooker()
        AppUserManager.shared.logout {
            self.displayErrorAlertWith(title: "Sad to see you go!", message: "Hope to hear back soon", completion: nil)
            self.viewlogin.isHidden = false
            self.viewYourData.isHidden = true
            self.hideLoadingCooker()
        } failure: { (error) in
            self.hideLoadingCooker()
            self.displayErrorAlertWith(title: "Error", message: error.localizedDescription, completion: nil)
        }
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.hideTextFields()
        self.resetError()
        self.dataChangeTextField.text = ""
        self.passwordTextField.text = ""
        self.repeatPasswordTextField.text = ""
        
        self.view.endEditing(true)
    }
    
    @IBAction func buttonFullname(_ sender: UIButton) {
        self.name.append(name)
    }
    
    @IBAction func buttonEmail(_ sender: UIButton) {
        self.email.append(email)
    }
    
    @IBAction func buttonPassword(_ sender: UIButton) {
        self.password.append(password)
    }
    
    
    @IBAction func btnOkDataChange(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showLoadingCooker()
        AppUserManager.shared.updateLoggedUserFullname(name: self.dataChangeTextField.text ?? "") { () -> Void in
            self.displaySuccessAlert(title: "Success", message: "Your name was changed") { (success) in
                self.fullNameLabel.text = self.dataChangeTextField.text
                self.dataChangeTextField.text = ""
                self.resetError()
                self.hideTextFields()
                self.hideLoadingCooker()
            }
            
        } failure: { (error) in
            self.hideLoadingCooker()
            self.showError(message: "Ops! There was someting wrong! Please, try again latter")
        }
    }
    
    
    @IBAction func btnOkEmailChange(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showLoadingCooker()
        AppUserManager.shared.updateUserLoggedEmail(email: self.dataChangeTextField.text ?? "", password: self.passwordTextField.text ?? "") {
            self.displaySuccessAlert(title: "Success", message: "Your email was changed") { (success) in
                self.emailLabel.text = self.dataChangeTextField.text
                self.dataChangeTextField.text = ""
                self.passwordTextField.text = ""
                self.resetError()
                self.hideTextFields()
                self.hideLoadingCooker()
            }
        } failure: { (error) in
            self.hideLoadingCooker()
            self.showError(message: "Ops! There was something wrong! Please, check your password")
        }
    }
    
    
    @IBAction func btnOkPasswordChange(_ sender: UIButton) {
        if self.passwordTextField.text != self.repeatPasswordTextField.text {
            self.showError(message: "Ops! Diffents passwords")
            return
        }
        self.view.endEditing(true)
        self.showLoadingCooker()
        AppUserManager.shared.updateUserLoggedPassword(currentPassword: self.dataChangeTextField.text ?? "", newPassword: self.passwordTextField.text ?? "") {
            self.displaySuccessAlert(title: "Success", message: "Your password was changed") { (success) in
                self.dataChangeTextField.text = ""
                self.passwordTextField.text = ""
                self.repeatPasswordTextField.text = ""
                self.resetError()
                self.hideTextFields()
                self.hideLoadingCooker()
            }
        } failure: { (error) in
            self.hideLoadingCooker()
            self.showError(message: "Ops! There was something wrong! Please, check your current password")
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsAuthVC",
           let settingsAuthVC = segue.destination as? SettingsAuthVC {
            settingsAuthVC.didLoginDelegate = self
        } else if segue.identifier == "SettingsCadVC",
                  let settingsCadVC = segue.destination as? SettingsCadVC {
            settingsCadVC.didLoginDelegate = self
        }
        if segue.identifier == "SettingsAuthVC" {
            let vc:SettingsAuthVC? = segue.destination as? SettingsAuthVC
            vc?.delegate = self
        }
        else if segue.identifier == "SettingsCadVC"{
            let vc:SettingsCadVC? = segue.destination as? SettingsCadVC
            vc?.delegate = self
        }
    }
    
    // MARK: VALIDACAO DO CAMPO EMAIL
    func validateTF(){
        if self.dataChangeTextField.text?.isEmpty == true {
            self.dataChangeTextField.layer.borderColor = UIColor.red.cgColor
            self.dataChangeTextField.layer.borderWidth = 1.0
            self.dataChangeTextField.attributedPlaceholder = NSAttributedString(string: "E-mail - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.dataChangeTextField.text?.isEmpty == false {
            self.dataChangeTextField.layer.borderWidth = 0
        }
        
        // MARK: VALIDACAO DO CAMPO SENHA
        if self.passwordTextField.text?.isEmpty == true {
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
            self.passwordTextField.layer.borderWidth = 1.0
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.passwordTextField.text?.isEmpty == false {
            self.passwordTextField.layer.borderWidth = 0
        }
        
        // MARK: VALIDACAO DO CAMPO REPET SENHA
        if self.repeatPasswordTextField.text?.isEmpty == true {
            self.repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor
            self.repeatPasswordTextField.layer.borderWidth = 1.0
            self.repeatPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Repet Password - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.repeatPasswordTextField.text?.isEmpty == false {
            self.repeatPasswordTextField.layer.borderWidth = 0
        }
    }
}


// MARK: extension TextField Delegate
extension SettingsViewControler: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.dataChangeTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.repeatPasswordTextField.becomeFirstResponder()
        default:
            self.repeatPasswordTextField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - extension DidLogindDelegate
extension SettingsViewControler: DidLoginDelegate {
    
    func handleDidLogin() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.transitionBackToReferrer()
        }
    }
}


// MARK: - extension SettingsCadVCDelegate, SettingAuthVCDelegate
extension SettingsViewControler: SettingsCadVCDelegate, SettingAuthVCDelegate {
    func hideViewFromLoginVC() {
        let user = AppUserManager.shared.loggedUser
        self.viewlogin.isHidden = true
        self.viewYourData.isHidden = false
        self.hideTextFields()
        self.emailLabel.text = user?.email
        self.fullNameLabel.text = user?.name
    }
    
    func hideViewFromSignUp() {
        let user = AppUserManager.shared.loggedUser
        self.viewlogin.isHidden = true
        self.viewYourData.isHidden = false
        self.hideTextFields()
        self.emailLabel.text = user?.email
        self.fullNameLabel.text = user?.name
    }
}

