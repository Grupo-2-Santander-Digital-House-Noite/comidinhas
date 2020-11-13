//
//  SettingsAuthVC.swift
//  Comidinhas
//
//  Created by Rodrigo Ventura on 09/11/20.
//

import UIKit

class SettingsAuthVC: UIViewController {

    @IBOutlet weak var bntConfirma: UIButton!
    
    
    fileprivate func configBntConfirmar() {
        self.bntConfirma.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configBntConfirmar()
        
        // Do any additional setup after loading the view.
    }
    


    @IBAction func bntConfirmarAC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let supd: SettingsUpdVC? = segue.destination as? SettingsUpdVC
//    }
}
