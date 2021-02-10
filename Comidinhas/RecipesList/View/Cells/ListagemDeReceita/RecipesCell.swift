//
//  RecipesCell.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import UIKit

class RecipesCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    func setup(receita: Recipe) {
        self.recipeImage.stopLoadingAnimation()
        self.recipeImage.layer.cornerRadius = 10
        self.recipeImage.downloaded(from: receita.image ?? "", contentMode: .scaleAspectFill)
        self.nameLabel.text = receita.name
        self.timeLabel.text = "\(receita.time ?? 0) minutes"
        self.categoryLabel.text = receita.categoryString
        self.servingsLabel.text = "\(receita.servings ?? 0) servings"
    }
    
    override func prepareForReuse() {
        recipeImage.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        categoryLabel.text = nil
        servingsLabel.text = nil
    }
}


// MARK: - extension UIImageView
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        self.startLoadingAnimation()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.stopLoadingAnimation()
                self?.image = image
            }
        }.resume()
    }
    
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    
    func startLoadingAnimation() {
        self.image = nil
        self.animationImages = []
        for var index in 1..<9 {
            if let image = UIImage(named: "loading-\(index)") {
                self.animationImages?.append(image)
            }
        }
        self.animationDuration = 0.4
        self.startAnimating()
    }
    
    
    func stopLoadingAnimation() {
        self.stopAnimating()
        self.animationImages = nil
    }
}
