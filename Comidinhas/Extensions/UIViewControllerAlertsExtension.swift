//
//  ViewControllerExtension.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 09/12/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayErrorAlertWith(title: String, message: String, dismissTitle: String? = "OK", completion: (() -> ())?, dismissAction: ((UIAlertAction) -> Void)? = nil) -> Void {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: dismissAction ?? nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: completion)
    }
    
    func displayConfirmationAlert(title: String, message: String, confirmTitle: String? = "Ok", cancelTitle: String? = "Cancel", confirmHandler: ((UIAlertAction) -> Void)?) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displaySuccessAlert(title: String, message:String, successHandler: ((UIAlertAction) -> Void)?) {
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: successHandler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
