//
//  DatabaseProtocol.swift
//  kenneth-a2
//
//  Created by user160075 on 5/3/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case group
    case cocktails
    case ingredients
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onGroupChange(change: DatabaseChange, cocktailGroup: [Cocktail])
    func onCocktailListChange(change: DatabaseChange, cocktails: [Cocktail])
    func onIngredientGroup(change: DatabaseChange, ingredients: [Ingredient])
}

protocol DatabaseProtocol: AnyObject {
    // Initialised group and ingredients
    var defaultGroup: CocktailGroup {get}
    var defaultIngredients: IngredientGroup {get}

    // Saving main context
    func cleanup()
    
    // Cocktail in main context
    func addCocktail(name: String, instructions: String) -> Cocktail
    func deleteCocktail(cocktail: Cocktail)
    
    // Creating a brand new cocktail
    func createNewDraftCocktail() -> Cocktail
    
    // Editing an existing cocktail
    func createCocktailDraft(from: Cocktail) -> Cocktail
    
    // For child context
    func saveDraft()
    func discardDraft()
    
    // New ingredient name
    func addIngredient(name: String) -> Ingredient
    
    // For Ingredient Measurements
    func addIngredientMeasurementToCocktail(cocktail: Cocktail, name: String, quantity: String) -> Bool
    func removeIngredientMeasurementFromCocktail(ingredientMeasurement: IngredientMeasurement, cocktail: Cocktail)

    // For cocktail groups
    func addGroup(groupName: String) -> CocktailGroup
    func deleteGroup(group: CocktailGroup)
    func addCocktailToGroup(cocktail: Cocktail, group: CocktailGroup) -> Bool
    func removeCocktailFromGroup(cocktail: Cocktail, group: CocktailGroup)
    
    // For ingredient groups
    func addIngredientGroup(groupName: String) -> IngredientGroup
    func addIngredientToGroup(ingredient: Ingredient, group: IngredientGroup) -> Bool
    
    // Listeners
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    // Valid cocktail checks
    func checkUniqueCocktailName(cocktail: Cocktail) -> Bool
    func checkExistsCocktailInGroup(cocktail: Cocktail, group: CocktailGroup) -> Bool
}
