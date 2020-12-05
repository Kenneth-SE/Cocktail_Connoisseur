//
//  DrinksSearch.swift
//  kenneth-a2
//
//  Created by user160075 on 5/5/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class DrinksSearch: NSObject, Decodable {
    var name: String?
    var instructions: String?
    var ingredientMeasurements: [[String]] = []
    
    private enum DrinkKeys: String, CodingKey {
        // API keys
        case name = "strDrink"
        case instructions = "strInstructions"
        
        case ingredients1 = "strIngredient1"
        case ingredients2 = "strIngredient2"
        case ingredients3 = "strIngredient3"
        case ingredients4 = "strIngredient4"
        case ingredients5 = "strIngredient5"
        case ingredients6 = "strIngredient6"
        case ingredients7 = "strIngredient7"
        case ingredients8 = "strIngredient8"
        case ingredients9 = "strIngredient9"
        case ingredients10 = "strIngredient10"
        case ingredients11 = "strIngredient11"
        case ingredients12 = "strIngredient12"
        case ingredients13 = "strIngredient13"
        case ingredients14 = "strIngredient14"
        case ingredients15 = "strIngredient15"
        
        case measurements1 = "strMeasure1"
        case measurements2 = "strMeasure2"
        case measurements3 = "strMeasure3"
        case measurements4 = "strMeasure4"
        case measurements5 = "strMeasure5"
        case measurements6 = "strMeasure6"
        case measurements7 = "strMeasure7"
        case measurements8 = "strMeasure8"
        case measurements9 = "strMeasure9"
        case measurements10 = "strMeasure10"
        case measurements11 = "strMeasure11"
        case measurements12 = "strMeasure12"
        case measurements13 = "strMeasure13"
        case measurements14 = "strMeasure14"
        case measurements15 = "strMeasure15"
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: DrinkKeys.self)
        
        // MARK: - Drink name
        if let drinkName = try? rootContainer.decode(String.self, forKey: .name) {
            name = drinkName
        }
        
        // MARK: - Drink instructions
        if let drinkInstructions = try? rootContainer.decode(String.self, forKey: .instructions) {
            instructions = drinkInstructions
        }
        
        // MARK: - Drink ingredients
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients1) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements1) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients2) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements2) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients3) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements3) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients4) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements4) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients5) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements5) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients6) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements6) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients7) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements7) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients8) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements8) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients9) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements9) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients10) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements10) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients11) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements11) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients12) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements12) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients13) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements13) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients14) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements14) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
        
        if let drinkIngredients = try? rootContainer.decode(String.self, forKey: .ingredients15) {
            if let drinkMeasurements = try? rootContainer.decode(String.self, forKey: .measurements15) {
                ingredientMeasurements.append([drinkIngredients, drinkMeasurements])
            }
        }
    }
}
