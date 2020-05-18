//
//  IngredientCell.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(from ingredient: Ingredient, and recipe: Recipe? = nil) {
        nameLabel.text = ingredient.name
        
        if let recipe = recipe, let ingredients = recipe.ingredients?.allObjects as? [Ingredient] {
            if ingredients.contains(ingredient) {
                self.accessoryType = .checkmark
            } else {
                self.accessoryType = .none
            }
            
        } else {
            self.accessoryType = .none
        }
    }

}
