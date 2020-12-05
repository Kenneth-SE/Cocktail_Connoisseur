//
//  Ingredient+CoreDataProperties.swift
//  kenneth-a2
//
//  Created by user160075 on 5/5/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredientGroups: NSSet?

}

// MARK: Generated accessors for ingredientGroups
extension Ingredient {

    @objc(addIngredientGroupsObject:)
    @NSManaged public func addToIngredientGroups(_ value: IngredientGroup)

    @objc(removeIngredientGroupsObject:)
    @NSManaged public func removeFromIngredientGroups(_ value: IngredientGroup)

    @objc(addIngredientGroups:)
    @NSManaged public func addToIngredientGroups(_ values: NSSet)

    @objc(removeIngredientGroups:)
    @NSManaged public func removeFromIngredientGroups(_ values: NSSet)

}
