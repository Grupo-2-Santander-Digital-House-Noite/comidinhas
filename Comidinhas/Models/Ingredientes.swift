//
//  Ingredientes.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import Foundation



struct Ingredites : Codable {
    var quantidade:Double?
    var unidade:String?
    var ingrediente:String
    
    enum CodingKeys: String, CodingKey {
        case quantidade = "amount"
        case unidade = "unit"
        case ingrediente = "name"
    }
}



var arrayIngredientesDough:[Ingredites] = [Ingredites(quantidade: 2, unidade: "cup", ingrediente: "flour"),
                                      Ingredites(quantidade: 2, unidade: "cup", ingrediente: "sugar"),
                                      Ingredites(quantidade: 1, unidade: "cup", ingrediente: "milk"),
                                      Ingredites(quantidade: 6, unidade: "tablespoon", ingrediente: "chocolate powder"),
                                      Ingredites(quantidade: 1, unidade: "tablespoon", ingrediente: "baking powder"),
                                      Ingredites(quantidade: 6, unidade: "unit", ingrediente: "egg"),
                                      Ingredites(quantidade: 1, unidade: "tablespoon", ingrediente: "yeast")]


var arrayIngredientesIcing:[Ingredites] = [Ingredites(quantidade: 2, unidade: "tablespoon", ingrediente: "butter"),
                                           Ingredites(quantidade: 2, unidade: "cup", ingrediente: "milk"),
                                           Ingredites(quantidade: 1, unidade: "cups", ingrediente: "chocolate powder")]


var arrayPartesDaReceita:[String] = ["Dough", "Icing"]

