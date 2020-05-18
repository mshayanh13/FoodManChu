//
//  SearchCell.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/7/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(option: String) {
        nameLabel.text = option.capitalized
        accessoryType = .none
    }

}
