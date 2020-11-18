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
    
    // MARK: Propriedades para o Interface Builder.
    @IBInspectable var name: String {
        set {
            self.recipeTitle?.text = newValue
        }
        get {
            return self.recipeTitle?.text ?? "Recipe Name"
        }
    }
    
    @IBInspectable var categoryText: String = "none" {
        didSet {
            self.recipeCategories?.text = categoryText
        }
    }
    
    @IBInspectable var minutesToPrepare: Int = 30 {
        didSet {
            self.timeLabel?.text = "\(minutesToPrepare) min"
        }
    }
    
    @IBInspectable var servesXPeople: Int = 1 {
        didSet {
            self.servingsLabel?.text = "\(servesXPeople) servings"
        }
    }
    
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
    
    /**
     Configura a view com a receita escolhida.
     */
    func configureViewWith(recipe: Recipe?) {
        self.recipeTitle?.text = recipe?.name ?? "Recipe Name"
        self.recipeCategories?.text = recipe?.categoryString ?? "none"
        self.timeLabel?.text = "\(recipe?.time ?? 0) min"
        self.servingsLabel?.text = "\(recipe?.servings ?? 0) servings"
    }
    
    // Este método é chamado pelo interface builder.
    // A gente usa ele para configurar a nossa view para o interface builder
    // com os valores defaults, que no nosso caso pode ser abreviado com
    // o método configureViewWith que quando não recebe uma recipe
    // aplica os valores defaults.
    override func prepareForInterfaceBuilder() {
        self.configureViewWith(recipe: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
