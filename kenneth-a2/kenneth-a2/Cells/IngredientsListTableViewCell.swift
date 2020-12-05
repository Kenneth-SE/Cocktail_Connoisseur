//
//  IngredientsListTableViewCell.swift
//  kenneth-a2
//
//  Created by user160075 on 4/30/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class IngredientsListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
