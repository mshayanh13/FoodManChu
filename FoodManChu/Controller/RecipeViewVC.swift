//
//  RecipeViewVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/7/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class RecipeViewVC: UIViewController {
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cookingInstructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var recipeToView: Recipe!
    var ingredients: [Ingredient]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
        disableEditing()
        loadRecipe()
    }
    
    func disableEditing() {
        recipeNameTextField.isUserInteractionEnabled = false
        prepTimeTextField.isUserInteractionEnabled = false
        descriptionTextView.isEditable = false
        cookingInstructionsTextView.isEditable = false
    }

}

extension RecipeViewVC {
    func loadRecipe() {
        if let recipe = recipeToView {
            recipeNameTextField.text = recipe.name
            prepTimeTextField.text = String(recipe.prepTime)
            descriptionTextView.text = recipe.details
            cookingInstructionsTextView.text = recipe.instructions
            categoryLabel.text = recipe.category?.type
            if let ingredients = recipe.ingredients?.allObjects as? [Ingredient] {
                self.ingredients = ingredients
                ingredientsTableView.reloadData()
            }
        }
    }
}

extension RecipeViewVC {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeViewVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let ingredientCell = tableView.dequeueReusableCell(withIdentifier: Utilities.shared.ingredientReuseId) as? IngredientCell {
            configureCell(ingredientCell, indexPath: indexPath)
            return ingredientCell
        } else {
            return IngredientCell()
        }
    }
    
    func configureCell(_ cell: IngredientCell, indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        cell.configureCell(from: ingredient)
    }
}
