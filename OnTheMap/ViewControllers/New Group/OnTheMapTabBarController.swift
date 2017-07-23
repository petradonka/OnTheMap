//
//  OnTheMapTabBarController.swift
//  OnTheMap
//
//  Created by Petra Donka on 23.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class OnTheMapTabBarController: UITabBarController, LogoutDelegate {

    @IBAction func handleLogoutTapped() {
        logout()
    }

    func dismissAfterLogout() {
        guard let selectedViewController = selectedViewController else {
            print("No selected view controller in tab bar controller")
            return
        }

        selectedViewController.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}
