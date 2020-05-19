//
//  Extension.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/17/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

extension String {
    func equalsToWhileIgnoringCaseAndWhitespace(_ string: String) -> Bool {
        return self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIViewController {
    func showTemporaryError(with title: String, for seconds: Double) {
        let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        let secondsToDismissAlert = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: secondsToDismissAlert, execute: {
            alert.dismiss(animated: true)
            })
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func confirmDelete(completion: @escaping ()->Void) {
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure that you would like to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { (action) in
                completion()
            })
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
