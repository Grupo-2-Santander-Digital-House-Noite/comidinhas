//
//  EntrarVC.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 01/12/20.
//

import UIKit

class EntrarVC: UIViewController {
    
    @IBOutlet weak var loggedView: UIView!
    @IBOutlet weak var changeNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var notLoggedView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // MARK: configView
    private func configView() {
        self.changeButton.layer.cornerRadius = 5
        self.logoutButton.layer.cornerRadius = 5
        self.loginButton.layer.cornerRadius = 5
        self.signUpButton.layer.cornerRadius = 5
        
        self.loggedView.isHidden = true
        
    }
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configView()
        // Do any additional setup after loading the view.
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginVC" {
            let vc:LoginVC? = segue.destination as? LoginVC
            vc?.delegate = self
        } else if segue.identifier == "SignUpVC" {
            let vc: SignUpVC? = segue.destination as? SignUpVC
            vc?.delegate = self
        }
    }
    
    // MARK: IBAction
    
    @IBAction func tappedChangeButton(_ sender: UIButton) {
    }
    
    
    @IBAction func tappedLogoutButton(_ sender: UIButton) {
    }
    
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUpVC", sender: nil)
    }
    
}


extension EntrarVC: LoginVCDelegate {
    func hideViewLogin() {
        self.loggedView.isHidden = false
        self.notLoggedView.isHidden = true
    }
}

extension EntrarVC: SignUpVCDelegate {
    func hideViewSignUp() {
        self.loggedView.isHidden = false
        self.notLoggedView.isHidden = true
    }
    
    
}
