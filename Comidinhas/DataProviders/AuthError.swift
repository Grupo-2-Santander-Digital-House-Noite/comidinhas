//
//  AuthError.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 01/12/20.
//

import Foundation

enum AuthError: Error {
    case userCreationError(localizedMessage: String)
    case userAuthenticationError(localizedMessage: String)
}
