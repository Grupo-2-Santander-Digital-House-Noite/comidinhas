//
//  Steps.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import Foundation


struct StepsSection: Codable {
    
    var name: String
    var steps: [Steps]
    
    enum CodingKeys: String, CodingKey {
        case name =  "name"
        case steps = "steps"
    }
}

struct Steps: Codable {
    var num:Int
    var step:String
    
    enum CodingKeys: String, CodingKey {
        case num = "number"
        case step = "step"
    }
}
