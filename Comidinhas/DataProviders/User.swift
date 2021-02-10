//
//  User.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 24/11/20.
//

import Foundation

/**
 Representa um usuário dentro do aplicativo.
 
 A classe User representa um usuário dentro do aplicativo, esta classe
 não possui um campo password neste momento porque não parece ser
 uma boa ideia armazenar a senha do usuário dentro do aplicativo.
 */
class User: Codable {
    let name: String? // Uma vez definidos não podem ser mudados!
    let email: String? // Uma vez definidos não podem ser mudados!
    let uid: String?
    
    init (name: String, email: String, uid: String? = nil) {
        self.name = name
        self.email = email
        self.uid = uid
    }  
}
