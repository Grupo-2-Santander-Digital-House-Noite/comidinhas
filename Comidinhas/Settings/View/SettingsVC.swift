////
////  SettingsVC.swift
////  Comidinhas
////
////  Created by Fabio Makihara on 21/10/20.
////
//
import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var editEmailLogin: UITextField!
    @IBOutlet weak var editPasswordLogin: UITextField!
    @IBOutlet weak var repetPasswordLogin: UITextField!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var bntLogin: UIButton!
    @IBOutlet weak var bntCancel: UIButton!
    @IBOutlet weak var bntSignup: UIButton!
    
    @IBOutlet weak var btnFullName: UIButton!
    @IBOutlet weak var viewYourData: UIView!
    @IBOutlet weak var viewlogin: UIView!
    
    
    
    // MARK: CONFIGURACAO GERAL DOS TEXTFIELDS
    fileprivate func configTextField() {
        self.editEmailLogin.delegate = self
        self.editPasswordLogin.delegate = self
        self.repetPasswordLogin.delegate = self

    }

    // MARK: CONFIGURACAO GERAL DOS BOTOES
    fileprivate func configButton() {
        self.bntLogin.layer.cornerRadius = 8
        self.bntCancel.layer.cornerRadius = 8
        self.bntSignup.layer.cornerRadius = 8
        self.btnLogout.layer.cornerRadius = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTextField()
        self.configButton()

  //       Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        validateTF()
    }
    @IBAction func btnLogin(_ sender: Any) {
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        AppUserManager.shared.logout {
            self.displayErrorAlertWith(title: "Sad to see you go!", message: "Hope to hear back soon", completion: nil)
        } failure: { (error) in
            self.displayErrorAlertWith(title: "Error", message: error.localizedDescription, completion: nil)
        }

        
    }
    @IBAction func btnCancel(_ sender: Any) {
    }
   
    @IBAction func buttonEmail(_ sender: Any) {
    }
    
    @IBAction func buttonPassword(_ sender: Any) {
    }
    
    @IBAction func btnOkDataChange(_ sender: Any) {
    }
    
    @IBAction func btnOkPasswordRepet(_ sender: Any) {
    }
    @IBAction func btnOkPassword(_ sender: Any) {
    }
    
    //    @IBAction func searchBarButtonClick(_ sender: UIBarButtonItem) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
//        let newViewController: SearchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//        newViewController.modalPresentationStyle = .overFullScreen
//        newViewController.delegate = self
//        self.present(newViewController, animated: true, completion: nil)
//    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsAuthVC",
           let settingsAuthVC = segue.destination as? SettingsAuthVC {
            settingsAuthVC.didLoginDelegate = self
        }
    }


//    @IBAction func bntActSigin(_ sender: UIButton) {
//
//        // MARK: VALIDACAO DO CAMPO EMAIL
    func validateTF(){
        if self.editEmailLogin.text?.isEmpty == true {
            self.editEmailLogin.layer.borderColor = UIColor.red.cgColor
            self.editEmailLogin.layer.borderWidth = 1.0
            self.editEmailLogin.attributedPlaceholder = NSAttributedString(string: "E-mail - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editEmailLogin.text?.isEmpty == false {
            self.editEmailLogin.layer.borderWidth = 0
        }

        // MARK: VALIDACAO DO CAMPO SENHA
        if self.editPasswordLogin.text?.isEmpty == true {
            self.editPasswordLogin.layer.borderColor = UIColor.red.cgColor
            self.editPasswordLogin.layer.borderWidth = 1.0
            self.editPasswordLogin.attributedPlaceholder = NSAttributedString(string: "Password - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.editPasswordLogin.text?.isEmpty == false {
            self.editPasswordLogin.layer.borderWidth = 0
        }
        
        // MARK: VALIDACAO DO CAMPO REPET SENHA
        
        if self.repetPasswordLogin.text?.isEmpty == true {
            self.repetPasswordLogin.layer.borderColor = UIColor.red.cgColor
            self.repetPasswordLogin.layer.borderWidth = 1.0
            self.repetPasswordLogin.attributedPlaceholder = NSAttributedString(string: "Repet Password - Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if self.repetPasswordLogin.text?.isEmpty == false {
            self.repetPasswordLogin.layer.borderWidth = 0
        }
//        if self.editEmailLogin.text?.isEmpty == false && self.editPasswordLogin.text?.isEmpty == false {
//            self.performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
//        }
    }
    
    @IBAction func bntbtnSignUpAC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsCadVC", sender: nil)
        
    }
    @IBAction func bntLoginAC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsAuthVC", sender: nil)
    }
}

//    @IBAction func tappedSignUpButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "SettingsCadVC", sender: nil)
//    }


extension SettingsVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editEmailLogin:
            self.editPasswordLogin.becomeFirstResponder()
        case self.editPasswordLogin:
            self.repetPasswordLogin.becomeFirstResponder()
        default:
            self.repetPasswordLogin.resignFirstResponder()
        }
        return true
    }

}

extension SettingsVC: DidLoginDelegate {
    
    func handleDidLogin() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.transitionBackToReferrer()
        }
    }
    
}
