//
//  IngredientGroup+CoreDataProperties.swift
//  kenneth-a2
//
//  Created by user160075 on 5/5/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension IngredientGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientGroup> {
        return NSFetchRequest<IngredientGroup>(entityName: "IngredientGroup")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension IngredientGroup {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}
