//
//  DrinkData.swift
//  kenneth-a2
//
//  Created by user160075 on 5/5/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class DrinkData: NSObject, Decodable {
    var drinks: [DrinksSearch]?

    private enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }
}
