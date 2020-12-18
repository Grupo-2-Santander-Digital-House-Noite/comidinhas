//
//  LoadingView.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 18/12/20.
//

import UIKit
import Lottie

class LoadingView: UIView {

    @IBOutlet weak var loadingCookerAnimation: AnimationView!
   
    func showLoading() {
        self.loadingCookerAnimation.loopMode = .loop
        self.loadingCookerAnimation.play()
    }
    
    
    func hideLoading() {
        self.loadingCookerAnimation.stop()
    }
}
