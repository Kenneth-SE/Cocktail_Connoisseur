//
//  IngredientsSearch.swift
//  kenneth-a2
//
//  Created by user160075 on 5/5/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class IngredientsSearch: NSObject, Decodable {
    var name: String = ""
    
    private enum IngredientKeys: String, CodingKey {
        // API keys
        case ingredient = "strIngredient1"
    }

    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: IngredientKeys.self)

        // Get the ingredient info
        if let ingredientName = try? rootContainer.decode(String.self, forKey: .ingredient) {
            name.append(ingredientName)
        }
    }
}
