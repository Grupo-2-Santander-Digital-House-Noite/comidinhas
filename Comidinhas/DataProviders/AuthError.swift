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
    case userUpdateError(localizedMessage: String)
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAuthenticationError(localizedMessage: let message):
            return message
        case .userCreationError(localizedMessage: let message) :
            return message
        case .userUpdateError(localizedMessage: let message) :
            return message
        }
    }
}
