//
//  RecipeMetadataView.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 18/11/20.
//

import UIKit

// @IBDesignable é o que faz com que a view seja renderizada
// quando está no interface builder.
@IBDesignable
class RecipeMetadataView: UIView, ComidinhasCustomView {

    // MARK: Strings que não queremos repetir hahahah
    private static let NIB_NAME: String = "RecipeMetadataView"
    // MARK: Outlets
    // Os outlets são privados porque a view é a única interessada em saber
    // como eles são configurados.
    @IBOutlet private weak var recipeTitle: UILabel?
    @IBOutlet private weak var recipeCategories: UILabel?
    @IBOutlet private weak var timeLabel: UILabel?
    @IBOutlet private weak var servingsLabel: UILabel?
    
    // Método padrão para inicalizar views usando um frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSelfWithView(named: RecipeMetadataView.NIB_NAME)
    }
    
    // Método requerido quando se extende uma view.
    // Acredito que é como o iOS instância as views.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureSelfWithView(named: RecipeMetadataView.NIB_NAME)
    }
    
    func configureView(withRecipe recipe: Recipe?) {
        self.recipeTitle?.text = recipe?.name ?? "N/A"
        self.recipeCategories?.text = recipe?.categoryString ?? "none"
        self.timeLabel?.text = "\(recipe?.time ?? 0) min"
        self.servingsLabel?.text = "\(recipe?.servings ?? 0) servings"
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
