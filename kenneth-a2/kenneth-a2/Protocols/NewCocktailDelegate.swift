//
//  NewCocktailDelegate.swift
//  kenneth-a2
//
//  Created by user160075 on 5/4/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation

protocol NewCocktailDelegate: AnyObject {
    func newName(name: String) -> Bool
    func newInstruction(instructions: String) -> Bool
    func newIngredientMeasurement(ingredientName: String, ingredientQuantity: String) -> Bool
}
