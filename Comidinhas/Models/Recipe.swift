//
//  Recipe.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 21/10/20.
//

import Foundation


struct Recipe {
    var name:String?
    var time:String?
    var category:String?
    var servings:String?
    var image:String?
}



var arrayreceitas:[Recipe] = [Recipe(name: "Chocolate cake", time: "40m", category: "Dessert", servings: "40 servings", image: "ChocolateCake"),
                         Recipe(name: "Rainbow cake", time: "3h 30m", category: "Dessert", servings: "16 servings", image: "RainbowCake"),
                         Recipe(name: "Tomato soup", time: "40m", category: "Soup", servings: "4 servings", image: "TomatoSoup"),
                         Recipe(name: "Chicken strogonoff", time: "1h", category: "Main course", servings: "4 servings", image: "ChickenStrogonoff"),
                         Recipe(name: "Hamburger", time: "30m", category: "Snack", servings: "2 servings", image: "Hamburger")]
