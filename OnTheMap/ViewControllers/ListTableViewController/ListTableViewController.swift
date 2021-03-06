//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, ErrorHandlerDelegate {

    fileprivate var originalInsets = UIEdgeInsets.zero

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
        return StudentInformations.sharedInstance.sortedStudentInformations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformationCell", for: indexPath)

        let studentInformation = StudentInformations.sharedInstance.sortedStudentInformations[indexPath.row]
        cell.textLabel?.text = studentInformation.fullName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInformation = StudentInformations.sharedInstance.sortedStudentInformations[indexPath.row]
        openStudentInformationURL(studentInformation)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func openStudentInformationURL(_ studentInformation: StudentInformation) {
        if let mediaURL = studentInformation.mediaURL, let url = URL.init(string: mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showErrorMessage("Not a URL")
        }
    }
}
