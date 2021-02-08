//
//  LoadingCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 17/12/20.
//

import UIKit
import Lottie

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loadingAnimationView: AnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLoading() {
        self.loadingAnimationView.loopMode = .loop
        self.loadingAnimationView.play()
        self.loadingAnimationView.animationSpeed = 5
    }
    
}
