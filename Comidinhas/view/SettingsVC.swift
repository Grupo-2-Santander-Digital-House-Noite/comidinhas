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
    
    
    fileprivate func configTextField() {
        self.editEmailLogin.delegate = self
        self.editPasswordLogin.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configTextField()

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
