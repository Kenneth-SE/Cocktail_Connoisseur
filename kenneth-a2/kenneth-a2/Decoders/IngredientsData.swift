//
//  IngredientsData.swift
//  kenneth-a2
//
//  Created by user160075 on 5/6/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class IngredientsData: NSObject, Decodable {
    var ingredients: [IngredientsSearch]?
    
    private enum CodingKeys: String, CodingKey {
        case ingredients = "drinks"
    }
}
