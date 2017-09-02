//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, ErrorHandlerDelegate {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomLayoutGuide.length, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        setupStudentInformations() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformations?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformationCell", for: indexPath)

        if let studentInformation = studentInformations?[indexPath.row] {
            cell.textLabel?.text = studentInformation.fullName
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let studentInformation = studentInformations?[indexPath.row] {
            openStudentInformationURL(studentInformation)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func openStudentInformationURL(_ studentInformation: StudentInformation) {
        if let url = URL.init(string: studentInformation.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showErrorMessage("\(studentInformation.mediaURL) is not a URL")
        }
    }
}
