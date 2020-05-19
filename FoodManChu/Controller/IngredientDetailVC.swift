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
    
    func checkDuplicateName(_ name: String, exclude: String = "") -> Bool {
        if let ingredients = Utilities.shared.ingredientController.fetchedObjects {
            for ingredient in ingredients {
                if let ingredientName = ingredient.name?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), ingredientName.equalsToWhileIgnoringCaseAndWhitespace(name), !ingredientName.equalsToWhileIgnoringCaseAndWhitespace(exclude) {
                    return true
                }
            }
        }
        
        return false
    }

}

extension IngredientDetailVC {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        if ingredientToEdit != nil {
            confirmDelete {
                Utilities.shared.context.delete(self.ingredientToEdit!)
                Utilities.shared.ad.saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            nameTextField.text = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let ingredientName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized, ingredientName != "" else { return }
        
        var ingredient: Ingredient!
        if ingredientToEdit != nil {
            
            if checkDuplicateName(ingredientName, exclude: ingredientToEdit!.name ?? "") {
                showTemporaryError(with: "Recipe with this name already exits. Please enter a new name.", for: 2)
                nameTextField.text = ingredientToEdit!.name
                return
            }
            
            ingredient = ingredientToEdit
        } else {
            if checkDuplicateName(ingredientName) {
                showTemporaryError(with: "Ingredient with this name already exits. Please enter a new name.", for: 2)
                return
            }
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
                deleteButton.isHidden = true
            } else {
                nameTextField.isEnabled = true
                deleteButton.isHidden = false
            }
        }
    }
}
