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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func bntConfirmarAC(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingsUpdVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let supd: SettingsUpdVC? = segue.destination as? SettingsUpdVC
    }
}
