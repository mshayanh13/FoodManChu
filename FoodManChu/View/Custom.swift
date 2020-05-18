//
//  Custom.swift
//  FoodManChu
//
//  Created by Mohammad Shayan on 5/9/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

extension UIView {
    func customizeView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.darkGray.cgColor
    }
}

@IBDesignable
class RoundButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
}

@IBDesignable
class RoundTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
}

@IBDesignable
class RoundTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
        addBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
        addBorder()
    }
    
    func addBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension UIViewController {
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

extension UITextField {
    func addDoneButton(selector: Selector) {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: selector)
        toolbar.setItems([flexible, barButton], animated: false)
        inputAccessoryView = toolbar
    }
}

extension UITextView {
    func addDoneButton(selector: Selector) {
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: selector)
        toolbar.setItems([flexible, barButton], animated: false)
        inputAccessoryView = toolbar
    }
}
