//
//  Category+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/6/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var type: String?
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension Category {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: Recipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: Recipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}
