//
//  LoginTextField.swift
//  OnTheMap
//
//  Created by Petra Donka on 11.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds);
        return bounds.insetBy(dx: 10, dy: 10)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds);
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
