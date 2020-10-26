//
//  ShoppingListItemStateEnum.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 24/10/20.
//

import Foundation

enum ShoppingListItemStateEnum {
    case MARCADO, DESMARCADO
    
    func toggle() -> ShoppingListItemStateEnum {
        return self == .DESMARCADO ? .MARCADO : .DESMARCADO
    }
}
