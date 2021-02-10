//
//  CustomViewExtension.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 18/11/20.
//  Adaptado do tutorial -> https://www.youtube.com/watch?v=-KTAgaX13s8
//

import Foundation
import UIKit

protocol ComidinhasCustomView: UIView {
    /**
     Método que carrega view a partir do nibName
     */
    func loadViewWith(nibName: String) -> UIView?
    
    func configureSelfWithView(named nibName: String) -> Void
    
}

extension ComidinhasCustomView {
    
    /**
    Instância view a partir do nome.
     
     - Parameter nibName: Nome do arquivo do XIB da view.
     - Returns: A view instantiated from the view
     */
    func loadViewWith(nibName: String) -> UIView? {
    
        // Representa a bundle da classe, se a gente conseguir ela.
        let bundle: Bundle? = Bundle(for: Self.self)
        // Tenta obter uma nib com o nome e bundle.
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        // Tenta retornar uma instância
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    /**
     Adiciona uma subview da view desejada.
     - Parameter named: O nome da nib a ser invocada
     - Returns: Void
     */
    func configureSelfWithView(named nibName: String) -> Void {
        
        // Tenta obter uma instância da view usando o método anterior.
        guard let view: UIView = self.loadViewWith(nibName: nibName) else { return }
        // Ajusta as dimensões do frame da view para o objeto que esta carregando.
        view.frame = self.bounds
        // Adiciona a view como uma subView.
        self.addSubview(view)
    }
}
