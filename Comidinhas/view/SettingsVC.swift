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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func bntActSigin(_ sender: UIButton) {
        
        // VALIDACAO DO CAMPO EMAIL
        if self.editEmailLogin.text?.isEmpty == true {
            self.editEmailLogin.layer.borderColor = UIColor.red.cgColor
            self.editEmailLogin.layer.borderWidth = 1.0
            self.editEmailLogin.attributedPlaceholder = NSAttributedString(string: "Campo Obrigatório", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmailLogin.text?.isEmpty == false {
            self.editEmailLogin.layer.borderWidth = 0
        }
        
        // VALIDACAO DO CAMPO SENHA
        if self.editPasswordLogin.text?.isEmpty == true {
            self.editPasswordLogin.layer.borderColor = UIColor.red.cgColor
            self.editPasswordLogin.layer.borderWidth = 1.0
            self.editPasswordLogin.attributedPlaceholder = NSAttributedString(string: "Campo Obrigatório", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPasswordLogin.text?.isEmpty == false {
            self.editPasswordLogin.layer.borderWidth = 0
        }
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
