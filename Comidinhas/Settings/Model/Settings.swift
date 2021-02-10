//
//  Settings.swift
//  Comidinhas
//
//  Created by Cátia Souza on 23/11/20.
//

import Foundation
import UIKit

class Settings {
 
    func isValidEmail(email: String) -> Bool{
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegex)
        
        return emailTest.evaluate(with: email)
    }
   
    func isPasswordValid( password: String) -> Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordTest.evaluate(with: password)
    }
    
    func confButton(button: UIButton){
        button.layer.cornerRadius = 18
    }
    
    func setupTF(textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.isHidden = false
    }
}


