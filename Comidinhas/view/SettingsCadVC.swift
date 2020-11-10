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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func bntCreateAcc(_ sender: UIButton) {
        
        // VALIDACAO DO CAMPO EMAIL
        if self.editFullName.text?.isEmpty == true {
            self.editFullName.layer.borderColor = UIColor.red.cgColor
            self.editFullName.layer.borderWidth = 1.0
            self.editFullName.attributedPlaceholder = NSAttributedString(string: "Campo Obrigatório", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editFullName.text?.isEmpty == false {
            self.editFullName.layer.borderWidth = 0
        }
        
        // VALIDACAO DO CAMPO SENHA
        if self.editEmail.text?.isEmpty == true {
            self.editEmail.layer.borderColor = UIColor.red.cgColor
            self.editEmail.layer.borderWidth = 1.0
            self.editEmail.attributedPlaceholder = NSAttributedString(string: "Campo Obrigatório", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmail.text?.isEmpty == false {
            self.editEmail.layer.borderWidth = 0
        }
        
        
        if self.editPassword.text?.isEmpty == true {
            self.editPassword.layer.borderColor = UIColor.red.cgColor
            self.editPassword.layer.borderWidth = 1.0
            self.editPassword.attributedPlaceholder = NSAttributedString(string: "Campo Obrigatório", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPassword.text?.isEmpty == false {
            self.editPassword.layer.borderWidth = 0
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
