//
//  StepToStepCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import UIKit

class StepToStepCell: UITableViewCell {

    @IBOutlet weak var numLabel:UILabel!
    @IBOutlet weak var stepLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupStep(step:Steps) {
        self.numLabel.text = "\(step.num)."
        self.stepLabel.text = step.step
    }
}
