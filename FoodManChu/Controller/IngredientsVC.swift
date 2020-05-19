//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import CoreData

class IngredientsVC: UIViewController {

    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
        setupIngredientControllerDelegate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utilities.shared.segue_edit_ingredient, let destination = segue.destination as? IngredientDetailVC, let ingredient = sender as? Ingredient {
            destination.ingredientToEdit = ingredient
        }
    }

}

extension IngredientsVC: UITableViewDataSource, UITableViewDelegate {
    
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let objects = Utilities.shared.ingredientController.fetchedObjects, objects.count > 0 {
            let ingredient = objects[indexPath.row]
            performSegue(withIdentifier: Utilities.shared.segue_edit_ingredient, sender: ingredient)
        }
    }
    
}

extension IngredientsVC: NSFetchedResultsControllerDelegate {
    
    func setupIngredientControllerDelegate() {
        Utilities.shared.ingredientController.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                ingredientsTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                ingredientsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                if let cell = ingredientsTableView.cellForRow(at: indexPath) as? IngredientCell {
                    configureCell(cell, indexPath: indexPath)
                }
            }
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                ingredientsTableView.deleteRows(at: [oldIndexPath], with: .fade)
                ingredientsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ingredientsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ingredientsTableView.endUpdates()
    }
}
