//
//  RecipesVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import CoreData

class RecipesVC: UIViewController {
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.dataSource = self
        recipesTableView.delegate = self
        
        setupRecipeControllerDelegate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utilities.shared.segue_edit_recipe, let destination = segue.destination as? RecipeDetailVC, let recipe = sender as? Recipe {
            destination.recipeToEdit = recipe
        }
    }

}

extension RecipesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Utilities.shared.ingredientController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = Utilities.shared.recipeController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let recipeCell = tableView.dequeueReusableCell(withIdentifier: Utilities.shared.recipeReuseId) as? RecipeCell {
            configureCell(recipeCell, indexPath: indexPath)
            return recipeCell
        } else {
            return RecipeCell()
        }
    }
    
    func configureCell(_ cell: RecipeCell, indexPath: IndexPath) {
        let recipe = Utilities.shared.recipeController.object(at: indexPath)
        cell.configureCell(recipe: recipe)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let objects = Utilities.shared.recipeController.fetchedObjects, objects.count > 0 {
            let recipe = objects[indexPath.row]
            performSegue(withIdentifier: Utilities.shared.segue_edit_recipe, sender: recipe)
        }
    }
}

extension RecipesVC: NSFetchedResultsControllerDelegate {
    func setupRecipeControllerDelegate() {
        Utilities.shared.recipeController.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                recipesTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                recipesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                if let cell = recipesTableView.cellForRow(at: indexPath) as? RecipeCell {
                    configureCell(cell, indexPath: indexPath)
                }
            }
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                recipesTableView.deleteRows(at: [oldIndexPath], with: .fade)
                recipesTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipesTableView.endUpdates()
    }
}
