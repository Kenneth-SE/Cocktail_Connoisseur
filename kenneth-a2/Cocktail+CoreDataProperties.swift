//
//  Cocktail+CoreDataProperties.swift
//  kenneth-a2
//
//  Created by user160075 on 5/3/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Cocktail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cocktail> {
        return NSFetchRequest<Cocktail>(entityName: "Cocktail")
    }

    @NSManaged public var name: String?
    @NSManaged public var instructions: String?
    @NSManaged public var cocktailGroup: NSSet?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for cocktailGroup
extension Cocktail {

    @objc(addCocktailGroupObject:)
    @NSManaged public func addToCocktailGroup(_ value: CocktailGroup)

    @objc(removeCocktailGroupObject:)
    @NSManaged public func removeFromCocktailGroup(_ value: CocktailGroup)

    @objc(addCocktailGroup:)
    @NSManaged public func addToCocktailGroup(_ values: NSSet)

    @objc(removeCocktailGroup:)
    @NSManaged public func removeFromCocktailGroup(_ values: NSSet)

}

// MARK: Generated accessors for ingredients
extension Cocktail {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: IngredientMeasurement)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: IngredientMeasurement)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}
