//
//  ErrorHandlerDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 01.09.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

protocol ErrorHandlerDelegate {
    func handleError(_ error: OnTheMapError)
    func showErrorMessage(_ message: String)
}

extension ErrorHandlerDelegate where Self: UIViewController {
    func handleError(_ error: OnTheMapError) {
        switch error {
        case .apiError(let string), .requestError(let string), .loginError(let string):
            showErrorMessage(string)
        case .noResults:
            showErrorMessage("We couldn't find anything 🤷🏼‍♀️")
        default:
            print(error)
            showErrorMessage("Something went wrong... 😶")
        }
    }

    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .`default`, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
