//
//  SearchVC.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/7/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import CoreData

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let options = ["Ingredient",
                   "Recipe Name",
                   "Recipe Description",
                   "Time",
                   "Category Type"]
    
    var optionSelected: String? {
        didSet {
            if optionSelected != nil {
                searchButton.isEnabled = true
                results = []
                resultsTableView.reloadData()
            } else {
                searchButton.isEnabled = false
            }
        }
    }
    
    var results: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBorders()
        
        searchButton.isEnabled = false
        
        searchBar.delegate = self
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.text = ""
        results = []
        optionSelected = nil
        searchTableView.reloadData()
        resultsTableView.reloadData()
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utilities.shared.segue_view_recipe, let destination = segue.destination as? RecipeViewVC, let recipe = sender as? Recipe {
            destination.recipeToView = recipe
        }
    }
    
    func setupBorders() {
        resultsTableView.layer.borderColor = UIColor.darkGray.cgColor
        resultsTableView.layer.borderWidth = 1.0
        
        searchTableView.layer.borderWidth = 1.0
        searchTableView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        search()
    }
    
    func search() {
        guard let text = searchBar.text, text != "", let optionSelected = optionSelected else { return }
        results = []
        var uniqueResults = Set<Recipe>()
        
        let recipeRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        let ingredientRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let categoryRequest = NSFetchRequest<Category>(entityName: "Category")
        let searchPredicate: NSPredicate
        
        switch optionSelected {
        case "Ingredient":
            searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
            break
        case "Recipe Name":
            searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
            break
        case "Recipe Description":
            searchPredicate = NSPredicate(format: "details CONTAINS[cd] %@", text)
            break
        case "Time":
            searchPredicate = NSPredicate(format: "prepTime <= %i", Int64(text) ?? -1)
            break
        case "Category Type":
            searchPredicate = NSPredicate(format: "type CONTAINS[cd] %@", text)
            break
        default:
            searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
            break
        }
        
        do {
            if optionSelected == "Category Type" {
                categoryRequest.predicate = searchPredicate
                let categoryResults: [Category] = try Utilities.shared.context.fetch(categoryRequest)
                for category in categoryResults {
                    if let recipes = category.recipe?.allObjects as? [Recipe] {
                        for recipe in recipes {
                            uniqueResults.insert(recipe)
                        }
                    }
                }
                results.append(contentsOf: uniqueResults)
            } else if optionSelected == "Ingredient" {
                ingredientRequest.predicate = searchPredicate
                let ingredientResults: [Ingredient] = try Utilities.shared.context.fetch(ingredientRequest)
                for ingredient in ingredientResults {
                    if let recipes = ingredient.recipe?.allObjects as? [Recipe] {
                        for recipe in recipes {
                            uniqueResults.insert(recipe)
                        }
                    }
                }
                results.append(contentsOf: uniqueResults)
            } else {
                recipeRequest.predicate = searchPredicate
                results = try Utilities.shared.context.fetch(recipeRequest)
            }
            
            if results.count == 0 {
                showTemporaryError(with: "No results found.", for: 0.7)
            }
            
            resultsTableView.reloadData()
        } catch let error {
            showError(error.localizedDescription)
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return options.count
        } else {
            return results.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            if let searchCell = tableView.dequeueReusableCell(withIdentifier: Utilities.shared.searchReuseId) as? SearchCell {
                let option = options[indexPath.row]
                searchCell.configureCell(option: option)
                return searchCell
            }
        } else {
            if let recipeCell = tableView.dequeueReusableCell(withIdentifier: Utilities.shared.recipeReuseId) as? RecipeCell {
                
                configureCell(recipeCell, indexPath: indexPath)
                return recipeCell
            }
        }
        return UITableViewCell()
    }
    
    func configureCell(_ cell: RecipeCell, indexPath: IndexPath) {
        let recipe = results[indexPath.row]
        cell.configureCell(recipe: recipe)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            if let _ = tableView.dequeueReusableCell(withIdentifier: Utilities.shared.searchReuseId, for: indexPath) as? SearchCell {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                optionSelected = options[indexPath.row]
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let recipe = results[indexPath.row]
            performSegue(withIdentifier: Utilities.shared.segue_view_recipe, sender: recipe)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if tableView == searchTableView {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            optionSelected = nil
        }
    }
}
