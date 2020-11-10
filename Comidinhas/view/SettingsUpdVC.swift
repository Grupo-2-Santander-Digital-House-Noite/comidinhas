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
    
    @IBAction func bntUpdate(_ sender: UIButton) {
        
        
        
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
