//
//  Utilities.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import CoreData

class Utilities {
    static var shared = Utilities()
    
    var materialKey: Bool
    let ad: AppDelegate
    let context: NSManagedObjectContext
    let searchReuseId: String = "SearchCell"
    let resultReuseId: String = "ResultCell"
    let recipeReuseId: String = "RecipeCell"
    let ingredientReuseId: String = "IngredientCell"
    let segue_new_ingredient: String = "NewIngredientSegue"
    let segue_edit_ingredient: String = "EditIngredientSegue"
    let segue_new_recipe: String = "NewRecipeSegue"
    let segue_edit_recipe: String = "EditRecipeSegue"
    let segue_view_recipe: String = "ViewRecipeSegue"
    
    var ingredientController: NSFetchedResultsController<Ingredient>!
    
    var categoryController: NSFetchedResultsController<Category>!
    
    var recipeController: NSFetchedResultsController<Recipe>!
    
    init() {
        materialKey = false
        ad = UIApplication.shared.delegate as! AppDelegate
        context = ad.persistentContainer.viewContext
        doCoreDataCheckAndSetup()
    }
    
}


extension Utilities {
    
    func doCoreDataCheckAndSetup() {
        checkAndSetupIngredientController()
        checkAndSetupCategoryController()
        checkAndSetupRecipeController()
    }
    
    func generateSystemIngredients() {
        let names = ["beef", "beans", "chicken", "chocolate", "fruit", "meat", "grains", "mushroom", "pasta", "potatoes", "poultry", "rice", "salmon", "seafood", "shrimp", "tofu", "turkey", "vegetable"]
        
        for name in names {
            let ingredient = Ingredient(context: context)
            ingredient.name = name.capitalized
            ingredient.createdBySystem = true
        }
        
        ad.saveContext()
    }
    
    func checkAndSetupIngredientController() {
        fetchIngredients()
        if ingredientController == nil || ingredientController.sections?.count == 0 || ingredientController.sections?.first?.numberOfObjects == 0 {
            generateSystemIngredients()
            fetchIngredients()
        }
    }
    
    func fetchIngredients() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.ingredientController = controller
        
        do {
            try controller.performFetch()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func checkAndSetupCategoryController() {
        fetchCategories()
        if categoryController == nil || categoryController.sections?.count == 0 || categoryController.sections?.first?.numberOfObjects == 0 {
            generateSystemCategories()
            fetchCategories()
        }
        
    }
    
    func generateSystemCategories() {
        let categories = ["Meat", "Vegetarian", "Vegan", "Paleo", "Keto"]
        
        for categoryName in categories {
            let category = Category(context: context)
            category.type = categoryName.capitalized
        }
        
        ad.saveContext()
    }
    
    func fetchCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sort = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.categoryController = controller
        
        do {
            try controller.performFetch()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func checkAndSetupRecipeController() {
        fetchRecipes()
    }
    
    func fetchRecipes() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.recipeController = controller
        
        do {
            try controller.performFetch()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}
