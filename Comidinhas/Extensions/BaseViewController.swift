//
//  BaseViewController.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 18/12/20.
//

import UIKit


class BaseViewController: UIViewController {
    var loadingCookerView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingCooker() {
        self.loadingCookerView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LoadingView
        
        self.loadingCookerView?.frame = self.view.frame
        self.view.addSubview(self.loadingCookerView ?? UIView())
        self.loadingCookerView?.showLoading()
    }
    
    func hideLoadingCooker() {
        self.loadingCookerView?.hideLoading()
        self.loadingCookerView?.isHidden = true
    }
}
