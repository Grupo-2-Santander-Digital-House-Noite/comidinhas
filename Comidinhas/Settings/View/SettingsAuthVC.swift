//
//  SettingsAuthVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

class SettingsAuthVC: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField! {
        didSet{
            textFieldEmail.tintColor = UIColor.lightGray
            textFieldEmail.setIcon(#imageLiteral(resourceName: "email"))
        }
    }
    @IBOutlet weak var textFieldSenha: UITextField! {
        didSet {
            textFieldSenha.tintColor = UIColor.lightGray
            textFieldSenha.setIcon(#imageLiteral(resourceName: "password"))
           }
    }
    
    @IBOutlet weak var lbErroMsg: UILabel!
    
    @IBOutlet weak var bntLogin: UIButton!
    @IBOutlet weak var bntForgotPass: UIButton!
    
    let controller = Settings()
    
    
    
    fileprivate func configBntLogin() {
        self.bntLogin.layer.cornerRadius = 5
    }
    
    fileprivate func configTextField() {
        self.textFieldEmail.delegate = self
        self.textFieldSenha.delegate = self
    }
    
    let bnt = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configBntLogin()
        self.configTextField()
        
        self.lbErroMsg.isHidden = true
        
        
        textFieldSenha.rightViewMode = .unlessEditing
        
        bnt.setImage(UIImage(named: "eyeclosed30"), for: .normal)
        bnt.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        //bnt.frame = CGRect(x: CGFloat(textFieldPassword.frame.size.width - 25), y: CGFloat(20), width: CGFloat(20), height: CGFloat(25))
        bnt.addTarget(self, action: #selector(self.bntPasswordShow), for: .touchUpInside)
        textFieldSenha.rightView = bnt
        textFieldSenha.rightViewMode = .always
        textFieldSenha.isSecureTextEntry = true
        
        
        // Do any additional setup after loading the view.
    }
    
    func validField(){
        let emailConf = controller.isValidEmail(email: self.textFieldEmail.text!)
        
        
        if self.textFieldSenha.text?.isEmpty == false {
            self.textFieldSenha.layer.borderWidth = 0
            self.textFieldSenha.isHidden = false
            } else {
                
                self.textFieldSenha.layer.borderColor = UIColor.red.cgColor
                self.textFieldSenha.layer.borderWidth = 1.0
                self.textFieldSenha.isHidden = false
//                self.editPassword.isSecureTextEntry = false
              self.textFieldSenha.placeholder = "Password - Required"
                self.lbErroMsg.isHidden = false
        }
        
        if self.textFieldEmail.text?.isEmpty == true {
            self.textFieldEmail.layer.borderColor = UIColor.red.cgColor
            self.textFieldEmail.layer.borderWidth = 1.0
            self.textFieldEmail.isHidden = false
            self.textFieldEmail.placeholder = "E-mail - Required"
            self.lbErroMsg.isHidden = false
            return
        } else if self.textFieldEmail.text?.isEmpty == false {
            self.textFieldEmail.layer.borderWidth = 0
        }
        //VALIDACAO DO CAMPO EMAIL
        if emailConf == true && self.textFieldEmail.text?.isEmpty == false {
            self.textFieldEmail.isHidden = false
        } else {
            
            self.textFieldEmail.layer.borderColor = UIColor.red.cgColor
            self.textFieldEmail.layer.borderWidth = 1.0
            self.textFieldEmail.placeholder = "E-mail - Syntax Incorrect"
        }
    }
    
    
    @IBAction func bntPasswordShow(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if ( sender as! UIButton).isSelected {
            self.textFieldSenha.isSecureTextEntry = false
            bnt.setImage(UIImage(named: "eyeopen30"), for: .normal)
        } else {
            self.textFieldSenha.isSecureTextEntry = true
            bnt.setImage(UIImage(named: "eyeclosed30"), for: .normal)
        }
    }
    
    
    
    @IBAction func bntLoginAC(_ sender: UIButton) {
        self.validField()
    }
    
    
    @IBAction func bntForgotPass(_ sender: UIButton) {
        
            
        let alert = UIAlertController(title: "Recovery E-mail", message: "Please enter your registered e-mail", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        
        
        let buttonOK = UIAlertAction(title: "OK", style: .default) {(success) in

        }
        alert.addAction(buttonOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let supd: SettingsUpdVC? = segue.destination as? SettingsUpdVC
    }
}


extension SettingsAuthVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.textFieldEmail:
            self.textFieldSenha.becomeFirstResponder()
        default:
            self.textFieldSenha.resignFirstResponder()
        }
        return true
    }
}


