//
//  Ingredientes.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import Foundation



struct Ingredients : Codable {
    var quantidade:Double?
    var unidade:String?
    var ingrediente:String
    
    enum CodingKeys: String, CodingKey {
        case quantidade = "amount"
        case unidade = "unit"
        case ingrediente = "name"
    }
}
