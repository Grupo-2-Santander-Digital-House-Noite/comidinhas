//
//  ConfirmVC.swift
//  Comidinhas
//
//  Created by Cátia Souza on 06/12/20.
//

import UIKit

class ConfirmVC: UIViewController
{

    @IBOutlet weak var btnConfirma: UIButton!
    @IBOutlet weak var emailTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnConfirma.layer.cornerRadius = 8
    }
    

    @IBAction func btnTapped(_ sender: Any) {
    }
    
}
