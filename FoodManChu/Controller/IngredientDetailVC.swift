//
//  IngredientDetailVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class IngredientDetailVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var ingredientToEdit: Ingredient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addDoneButton(selector: #selector(tapDone(sender:)))
        
        if ingredientToEdit != nil {
            loadIngredient()
        } else {
            nameTextField.text = ""
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        nameTextField.text = ""
        super.viewDidDisappear(animated)
    }

}

extension IngredientDetailVC {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        if ingredientToEdit != nil {
            Utilities.shared.context.delete(ingredientToEdit!)
            Utilities.shared.ad.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            nameTextField.text = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let ingredientName = nameTextField.text, ingredientName != "" else { return }
        
        var ingredient: Ingredient!
        if ingredientToEdit != nil {
            ingredient = ingredientToEdit
        } else {
            ingredient = Ingredient(context: Utilities.shared.context)
        }
        
        ingredient.name = ingredientName
        
        Utilities.shared.ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}

extension IngredientDetailVC {
    func loadIngredient() {
        if let ingredient = ingredientToEdit {
            nameTextField.text = ingredient.name
            if ingredient.createdBySystem {
                nameTextField.isEnabled = false
                deleteButton.isEnabled = false
            } else {
                nameTextField.isEnabled = true
                deleteButton.isEnabled = true
            }
        }
    }
}
