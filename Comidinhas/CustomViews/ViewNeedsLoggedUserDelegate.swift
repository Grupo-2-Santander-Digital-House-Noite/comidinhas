//
//  RecipeMetadataNeedsLoggedUserDelegate.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 09/12/20.
//

import Foundation

protocol ViewNeedsLoggedUserDelegate: AnyObject {
    func didNeedALoggedUserTo(reason: String)
}
