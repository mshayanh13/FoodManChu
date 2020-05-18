//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    
    func configureCell(recipe: Recipe) {
        recipeNameLabel.text = recipe.name
    }

}
