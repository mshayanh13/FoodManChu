//
//  ResultCell.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/7/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    
    func configureCell(name: String) {
        recipeNameLabel.text = name
    }

}
