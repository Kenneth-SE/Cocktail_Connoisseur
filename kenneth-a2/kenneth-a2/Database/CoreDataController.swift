//
//  CoreDataController.swift
//  kenneth-a2
//
//  Created by user160075 on 5/3/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
    
    // Constants
    let INGREDIENTS_REQUEST_STRING = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
    let DEFAULT_GROUP_NAME = "My Drinks"
    let DEFAULT_INGREDIENTS_GROUP_NAME = "Default Ingredients"
    
    // Listener
    var listeners = MulticastDelegate<DatabaseListener>()
    
    // Context
    var persistentContainer: NSPersistentContainer
    let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    // Fetched Results Controllers
    var allCocktailsFetchedResultsController: NSFetchedResultsController<Cocktail>?
    var groupCocktailsFetchedResultsController: NSFetchedResultsController<Cocktail>?
    var allIngredientsFetchedResultsController: NSFetchedResultsController<Ingredient>?

    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "A2-Drinks")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        // Setup parent context
        childContext.parent = self.persistentContainer.viewContext

        super.init()

        // If no cocktails in the database we assume this is the first time the app runs
        // Create a default group and initial cocktails in this case
        if fetchAllCocktails().count == 0 {
            createDefaultEntries()
        }
    }

    // MARK: - Lazy Initization of Default Team
    lazy var defaultGroup: CocktailGroup = {
        var groups = [CocktailGroup]()

        // Fetch
        let request: NSFetchRequest<CocktailGroup> = CocktailGroup.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_GROUP_NAME)
        request.predicate = predicate

        do {
            try groups = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }

        // If no cocktail group exists initialise it
        if groups.count == 0 {
            return addGroup(groupName: DEFAULT_GROUP_NAME)
        }

        // First group is default
        return groups.first!
    }()
    
    // MARK: - Lazy Initization of Default Ingredients
    lazy var defaultIngredients: IngredientGroup = {
        var ingredients = [IngredientGroup]()
        
        // Fetch
        let request: NSFetchRequest<IngredientGroup> = IngredientGroup.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_INGREDIENTS_GROUP_NAME)
        request.predicate = predicate

        do {
            try ingredients = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }

        // If no ingredient group exists initialise it
        if ingredients.count == 0 {
            return addIngredientGroup(groupName: DEFAULT_INGREDIENTS_GROUP_NAME)
        }

        // First group is default
        return ingredients.first!
    }()
    
    func saveContext() {
        // Save main context
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }

    // MARK: - Database Protocol Functions
    
    // Save all contexts
    func cleanup() {
        saveDraft()
        saveContext()
    }
    
    // Save child context
    func saveDraft() {
        if childContext.hasChanges {
            do {
                try childContext.save()
            } catch {
                fatalError("Failed to save to main context: \(error)")
            }
        }
    }
    
    // Discard child context
    func discardDraft() {
        childContext.rollback()
    }

    // Add new cocktail
    func addCocktail(name: String, instructions: String) -> Cocktail {
        let cocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: persistentContainer.viewContext) as! Cocktail
        cocktail.name = name
        cocktail.instructions = instructions
        
        return cocktail
    }
    
    // Delete cocktail from core data
    func deleteCocktail(cocktail: Cocktail) {
        persistentContainer.viewContext.delete(cocktail)
    }
    
    // Setup a new cocktail
    func createNewDraftCocktail() -> Cocktail {
        let newCocktail = NSEntityDescription.insertNewObject(forEntityName: "Cocktail", into: childContext) as! Cocktail
        
        return newCocktail
    }
    
    // Edit an existing cocktail through the child context
    func createCocktailDraft(from: Cocktail) -> Cocktail {
        return (childContext.object(with: from.objectID) as? Cocktail)!
    }
    
    // Add a new ingredient to core data
    func addIngredient(name: String) -> Ingredient {
        let ingredient = fetchIngredient(name: name)
        
        if ingredient.name == nil {
            ingredient.name = name
        }
        
        return ingredient
    }
    
    // Add/edit a new ingredient measurement to an existing cocktail
    func addIngredientMeasurementToCocktail(cocktail: Cocktail, name: String, quantity: String) -> Bool {
        // If possible edit the existing ingredient measurement
        let ingredients = cocktail.ingredients?.allObjects as! [IngredientMeasurement]
        for ingredient in ingredients {
            if ingredient.name == name {
                ingredient.quantity = quantity
                return false
            }
        }

        // Add a new ingredient measurement
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: cocktail.managedObjectContext!) as! IngredientMeasurement
        ingredientMeasurement.name = name
        ingredientMeasurement.quantity = quantity
        
        cocktail.addToIngredients(ingredientMeasurement)
        return true
    }
    
    // Remove ingredient measurement from an existing cocktail
    func removeIngredientMeasurementFromCocktail(ingredientMeasurement: IngredientMeasurement, cocktail: Cocktail) {
        cocktail.removeFromIngredients(ingredientMeasurement)
    }

    // Add a new cocktail group
    func addGroup(groupName: String) -> CocktailGroup {
        let group = NSEntityDescription.insertNewObject(forEntityName: "CocktailGroup", into: persistentContainer.viewContext) as! CocktailGroup
        group.name = groupName

        return group
    }
    
    // Remove a cocktail group
    func deleteGroup(group: CocktailGroup) {
        persistentContainer.viewContext.delete(group)
    }

    // Add a cocktail to a cocktail group
    func addCocktailToGroup(cocktail: Cocktail, group: CocktailGroup) -> Bool {
        guard let cocktails = group.cocktails, cocktails.contains(cocktail) == false else {
            return false
        }

        group.addToCocktails(cocktail)
        return true
    }
    
    // Remove a cocktail from a cocktail group
    func removeCocktailFromGroup(cocktail: Cocktail, group: CocktailGroup) {
        group.removeFromCocktails(cocktail)
    }
    
    // Add an ingredient group
    func addIngredientGroup(groupName: String) -> IngredientGroup {
        let group = NSEntityDescription.insertNewObject(forEntityName: "IngredientGroup", into: persistentContainer.viewContext) as! IngredientGroup
        group.name = groupName
        
        return group
    }
    
    // Add an ingredient to a group
    func addIngredientToGroup(ingredient: Ingredient, group: IngredientGroup) -> Bool {
        guard let ingredients = group.ingredients, ingredients.contains(ingredient) == false else {
            return false
        }
        
        group.addToIngredients(ingredient)
        return true
    }
    
    // Check if the cocktail name exists in core data
    func checkUniqueCocktailName(cocktail: Cocktail) -> Bool {
        let cocktails = fetchAllCocktails()
        
        for existingCocktail in cocktails {
            if cocktail.name == existingCocktail.name, cocktail != existingCocktail {
                return false
            }
        }
        
        return true
    }
    
    // Check if the cocktail exists in the default cocktails group
    func checkExistsCocktailInGroup(cocktail: Cocktail, group: CocktailGroup) -> Bool {
        if group.cocktails?.contains(cocktail) ?? false {
            return false
        }
        
        return true
    }

    // Adding listeners
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)

        if listener.listenerType == .group || listener.listenerType == .all {
            listener.onGroupChange(change: .update, cocktailGroup: fetchGroupCocktails())
        }

        if listener.listenerType == .cocktails || listener.listenerType == .all {
            listener.onCocktailListChange(change: .update, cocktails: fetchAllCocktails())
        }
        
        if listener.listenerType == .ingredients || listener.listenerType == .all {
            listener.onIngredientGroup(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    // Removing listeners
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    // MARK: - Fetched Results Controller Protocol Functions
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allCocktailsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .cocktails || listener.listenerType == .all {
                    listener.onCocktailListChange(change: .update, cocktails: fetchAllCocktails())
                }
            }
        } else if controller == groupCocktailsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .group || listener.listenerType == .all {
                    listener.onGroupChange(change: .update, cocktailGroup: fetchGroupCocktails())
                }
            }
        } else if controller == allIngredientsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .ingredients || listener.listenerType == .all {
                    listener.onIngredientGroup(change: .update, ingredients: fetchAllIngredients())
                }
            }
        }
    }

    // MARK: - Core Data Fetch Requests
    func fetchAllCocktails() -> [Cocktail] {
        // If results controller not currently initialized
        if allCocktailsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Cocktail> = Cocktail.fetchRequest()
            
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // Initialize Results Controller
            allCocktailsFetchedResultsController = NSFetchedResultsController<Cocktail>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext,sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allCocktailsFetchedResultsController?.delegate = self

            do {
                try allCocktailsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }

        var cocktails = [Cocktail]()
        if allCocktailsFetchedResultsController?.fetchedObjects != nil {
            cocktails = (allCocktailsFetchedResultsController?.fetchedObjects)!
        }

        return cocktails
    }
    
    func fetchAllIngredients() -> [Ingredient] {
        // If ingredients controller not currently initialized
        if allIngredientsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Initialize Results Controller
            allIngredientsFetchedResultsController = NSFetchedResultsController<Ingredient>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allIngredientsFetchedResultsController?.delegate = self
            
            do {
                try allIngredientsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var ingredients = [Ingredient]()
        if allIngredientsFetchedResultsController?.fetchedObjects != nil {
            ingredients = (allIngredientsFetchedResultsController?.fetchedObjects)!
        }
        
        return ingredients
    }
    
    func fetchIngredient(name: String) -> Ingredient {
        // If it exists return the ingredient
        let ingredients = fetchAllIngredients()
        for ingredient in ingredients {
            if ingredient.name == name {
                return ingredient
            }
        }
        
        // Return a new ingedient
        return NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: persistentContainer.viewContext) as! Ingredient
    }

    func fetchGroupCocktails() -> [Cocktail] {
        // If group cocktails controller not currently initialized
        if groupCocktailsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Cocktail> = Cocktail.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY groups.name == %@", DEFAULT_GROUP_NAME)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            // Initialize Results Controller
            groupCocktailsFetchedResultsController = NSFetchedResultsController<Cocktail>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            groupCocktailsFetchedResultsController?.delegate = self

            do {
                try groupCocktailsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var cocktails = [Cocktail]()
        if groupCocktailsFetchedResultsController?.fetchedObjects != nil {
            cocktails = (groupCocktailsFetchedResultsController?.fetchedObjects)!
        }

        return cocktails
    }
    
    // MARK: - Default Entry Generation
    func createDefaultEntries() {
        let cocktail = addCocktail(name: "Martini", instructions: "Straight: Pour all ingredients into mixing glass with ice cubes. Stir well. Stain in chilled martini cocktail glass. Squeeze oil from lemon peel onto the drink, or garnish with olive.")
        let _ = addIngredientMeasurementToCocktail(cocktail: cocktail, name: "Dry Vermouth", quantity: "1/3 oz")
        let _ = addIngredientMeasurementToCocktail(cocktail: cocktail, name: "Gin", quantity: "1 2/3 oz")
        let _ = addIngredientMeasurementToCocktail(cocktail: cocktail, name: "Olive", quantity: "1")
        let _ = addCocktailToGroup(cocktail: cocktail, group: defaultGroup)
        
        let i1 = addIngredient(name: "Dry Vermouth")
        let i2 = addIngredient(name: "Gin")
        let i3 = addIngredient(name: "Olive")
        let i4 = addIngredient(name: "Ice cube")
        
        let _ = addIngredientToGroup(ingredient: i1, group: defaultIngredients)
        let _ = addIngredientToGroup(ingredient: i2, group: defaultIngredients)
        let _ = addIngredientToGroup(ingredient: i3, group: defaultIngredients)
        let _ = addIngredientToGroup(ingredient: i4, group: defaultIngredients)
        
        requestIngredients()
    }
    
    // MARK: - Web Request

    func requestIngredients() {
        let searchString = INGREDIENTS_REQUEST_STRING
        let jsonURL =
            URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }

            // Decode web API call
            do {
                let decoder = JSONDecoder()
                let drinkData = try decoder.decode(IngredientsData.self, from: data!)
                if let ingredients = drinkData.ingredients {
                    for ingredient in ingredients {
                        let i1 = self.addIngredient(name: ingredient.name)
                        let _ = self.addIngredientToGroup(ingredient: i1, group: self.defaultIngredients)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
}
