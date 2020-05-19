//
//  RecipeDetailVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cookingInstructionsTextView: UITextView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var duplicateButton: UIButton!
    
    var recipeToEdit: Recipe?
    var ingredientsSelected = Set<Ingredient>()
    var categorySelected: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtons()
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        loadRecipe()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        reset()
        super.viewDidDisappear(animated)
    }
    
    func addDoneButtons() {
        let textFieldsViews = [recipeNameTextField, prepTimeTextField, descriptionTextView, cookingInstructionsTextView]
        
        for item in textFieldsViews {
            if let item = item as? UITextField {
                item.addDoneButton(selector: #selector(tapDone(sender:)))
            } else if let item = item as? UITextView {
                item.addDoneButton(selector: #selector(tapDone(sender:)))
            }
        }
    }
    
    func reset() {
        recipeNameTextField.text = ""
        prepTimeTextField.text = ""
        descriptionTextView.text = ""
        cookingInstructionsTextView.text = ""
        categorySelected = Utilities.shared.categoryController.fetchedObjects?[0]
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        categoryLabel.text = Utilities.shared.categoryController.fetchedObjects?[categoryPickerView.selectedRow(inComponent: 0)].type?.capitalized
        ingredientsSelected.removeAll()
        
    }

    func checkDuplicateName(_ name: String, exclude: String = "") -> Bool {
        if let recipes = Utilities.shared.recipeController.fetchedObjects {
            for recipe in recipes {
                if let recipeName = recipe.name?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), recipeName.equalsToWhileIgnoringCaseAndWhitespace(name), !recipeName.equalsToWhileIgnoringCaseAndWhitespace(exclude) {
                    return true
                }
            }
        }
        
        return false
    }
    
}

extension RecipeDetailVC {
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if recipeToEdit != nil {
            confirmDelete {
                Utilities.shared.context.delete(self.recipeToEdit!)
                Utilities.shared.ad.saveContext()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            reset()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let recipeName = recipeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized, recipeName != "" else { return }
        
        var recipe: Recipe!
        if recipeToEdit != nil {
            if checkDuplicateName(recipeName, exclude: recipeToEdit!.name ?? "") {
                showTemporaryError(with: "Recipe with this name already exits. Please enter a new name.", for: 2)
                recipeNameTextField.text = recipeToEdit!.name
                return
            }
            
            recipe = recipeToEdit
        } else {
            if checkDuplicateName(recipeName) {
                showTemporaryError(with: "Recipe with this name already exits. Please enter a new name.", for: 2)
                return
            }
            
            recipe = Recipe(context: Utilities.shared.context)
        }
        
        recipe.name = recipeName
        recipe.prepTime = Int64(prepTimeTextField.text ?? "0") ?? 0
        recipe.details = descriptionTextView.text
        recipe.instructions = cookingInstructionsTextView.text
        recipe.category = categorySelected
        
        Utilities.shared.ad.saveContext()
        
        recipe.ingredients = Set(ingredientsSelected) as NSSet
        Utilities.shared.ad.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func duplicateButtonTapped(_ sender: UIButton) {
        loadRecipe()
        recipeToEdit = nil
        if let nameText = recipeNameTextField.text {
            recipeNameTextField.text = "\(nameText) - Copy"
        }
    }
}

extension RecipeDetailVC {
    func loadRecipe() {
        if let recipe = recipeToEdit {
            recipeNameTextField.text = recipe.name
            prepTimeTextField.text = String(recipe.prepTime)
            descriptionTextView.text = recipe.details
            cookingInstructionsTextView.text = recipe.instructions
            categorySelected = recipe.category
            if let categorySelected = categorySelected {
                let row = Utilities.shared.categoryController.fetchedObjects?.firstIndex(of: categorySelected)
                categoryPickerView.selectRow(row!, inComponent: 0, animated: true)
                categoryLabel.text = categorySelected.type?.capitalized
            }
            if let recipeIngredients = recipe.ingredients as? Set<Ingredient> {
                ingredientsSelected = recipeIngredients
            }
            duplicateButton.isHidden = false
        } else {
            reset()
            duplicateButton.isHidden = true
        }
    }
}

extension RecipeDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Utilities.shared.ingredientController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = Utilities.shared.ingredientController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
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
        let ingredient = Utilities.shared.ingredientController.object(at: indexPath)
        cell.configureCell(from: ingredient)
        if ingredientsSelected.contains(ingredient) {
            ingredientsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = Utilities.shared.ingredientController.object(at: indexPath)
        ingredientsSelected.insert(ingredient)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let ingredient = Utilities.shared.ingredientController.object(at: indexPath)
        let index = ingredientsSelected.firstIndex(of: ingredient)!
        ingredientsSelected.remove(at: index)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

extension RecipeDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let categories = Utilities.shared.categoryController.fetchedObjects {
            return categories.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Utilities.shared.categoryController.fetchedObjects?[row].type?.capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let categories = Utilities.shared.categoryController.fetchedObjects {
            let category = categories[row]
            categorySelected = category
            let type = category.type!
            categoryLabel.text = type.capitalized
        }
    }
}
