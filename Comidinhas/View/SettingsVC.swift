//
//  SettingsVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var editEmailLogin: UITextField!
    @IBOutlet weak var editPasswordLogin: UITextField!
    
    @IBOutlet weak var bntLogin: UIButton!
    @IBOutlet weak var bntCancel: UIButton!
    
    @IBOutlet weak var bntSignup: UIButton!
    
    
    // CONFIGURACAO GERAL DOS TEXTFIELDS
    fileprivate func configTextField() {
        self.editEmailLogin.delegate = self
        self.editPasswordLogin.delegate = self
        
        
    }
    
    // CONFIGURACAO GERAL DOS BOTOES
    fileprivate func configButton() {
        self.bntLogin.layer.cornerRadius = 5
        self.bntCancel.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTextField()
        self.configButton()

 
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBarButtonClick(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let newViewController: SearchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        newViewController.modalPresentationStyle = .overFullScreen
        newViewController.delegate = self
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation


    @IBAction func bntActSigin(_ sender: UIButton) {
        
        // VALIDACAO DO CAMPO EMAIL
        if self.editEmailLogin.text?.isEmpty == true {
            self.editEmailLogin.layer.borderColor = UIColor.red.cgColor
            self.editEmailLogin.layer.borderWidth = 1.0
            self.editEmailLogin.attributedPlaceholder = NSAttributedString(string: "E-mail - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmailLogin.text?.isEmpty == false {
            self.editEmailLogin.layer.borderWidth = 0
        }
        
        // VALIDACAO DO CAMPO SENHA
        if self.editPasswordLogin.text?.isEmpty == true {
            self.editPasswordLogin.layer.borderColor = UIColor.red.cgColor
            self.editPasswordLogin.layer.borderWidth = 1.0
            self.editPasswordLogin.attributedPlaceholder = NSAttributedString(string: "Password - mandatory", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPasswordLogin.text?.isEmpty == false {
            self.editPasswordLogin.layer.borderWidth = 0
        }
        
        
        if self.editEmailLogin.text?.isEmpty == false && self.editPasswordLogin.text?.isEmpty == false {
            self.performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
        }
    }
    
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsCadVC", sender: nil)
    }
    
}





extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editEmailLogin:
            self.editPasswordLogin.becomeFirstResponder()
        default:
            self.editPasswordLogin.resignFirstResponder()
        }
        return true
    }
    
}

extension SettingsVC: SearchVCDelegate {
    func returnTabBar() {
        self.tabBarController?.selectedIndex = 0
    }
}
