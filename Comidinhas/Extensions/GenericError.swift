//
//  GenericError.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 16/12/20.
//

import Foundation

enum GenericError: Error, LocalizedError {
    case GenericError
    case GenericErrorWithMessage(message:String)
    
    var errorDescription: String? {
        switch self {
        case .GenericError:
            return "An error has been issued"
        case .GenericErrorWithMessage(message: let errorMessage):
            return errorMessage
        }
    }
}
