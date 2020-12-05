//
//  CocktailGroup+CoreDataProperties.swift
//  kenneth-a2
//
//  Created by user160075 on 5/4/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension CocktailGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocktailGroup> {
        return NSFetchRequest<CocktailGroup>(entityName: "CocktailGroup")
    }

    @NSManaged public var name: String?
    @NSManaged public var cocktails: NSSet?

}

// MARK: Generated accessors for cocktails
extension CocktailGroup {

    @objc(addCocktailsObject:)
    @NSManaged public func addToCocktails(_ value: Cocktail)

    @objc(removeCocktailsObject:)
    @NSManaged public func removeFromCocktails(_ value: Cocktail)

    @objc(addCocktails:)
    @NSManaged public func addToCocktails(_ values: NSSet)

    @objc(removeCocktails:)
    @NSManaged public func removeFromCocktails(_ values: NSSet)

}
