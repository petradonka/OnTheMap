//
//  OnTheMapTabBarController.swift
//  OnTheMap
//
//  Created by Petra Donka on 23.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class OnTheMapTabBarController: UITabBarController, ErrorHandlerDelegate, LogoutDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var addPinButton: UIBarButtonItem!

    // MARK: - Refresh

    @IBAction func handleRefreshTapped(_ sender: Any) {
        refreshSelectedVC()
    }

    private func refreshSelectedVC() {
        guard let selectedViewController = selectedViewController else {
            print("No selected view controller in tab bar controller")
            return
        }

        guard let selectedRefreshableViewController = selectedViewController as? Refreshable else {
            print("View controller is not Refreshable")
            return
        }

        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        let activityIndicatorBarButtonItem = UIBarButtonItem.init(customView: activityIndicator)
        let refreshBarButtonItem = navigationController?.navigationBar.topItem?.rightBarButtonItem

        navigationController?.navigationBar.topItem?.rightBarButtonItem = activityIndicatorBarButtonItem
        selectedRefreshableViewController.refresh() {
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.topItem?.rightBarButtonItem = refreshBarButtonItem
            }
        }
    }

    // MARK: - Logout

    @IBAction func handleLogoutTapped() {
        logoutButton.isEnabled = false
        refreshButton.isEnabled = false
        logout(complete: dismissAfterLogout)
    }

    // MARK: - LogoutDelegate

    func dismissAfterLogout() {
        guard let selectedViewController = selectedViewController else {
            print("No selected view controller in tab bar controller")
            return
        }

        selectedViewController.performSegue(withIdentifier: "logoutSegue", sender: self)
    }

}
