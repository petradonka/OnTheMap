//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, StudentInformationDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        setupStudentInformations()
    }

    func setupStudentInformations(andFetch shouldFetch: Bool = false) {
        // show loading indicator
        if !shouldFetch, let studentInformations = studentInformations {
            print(studentInformations.count)
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if let studentInformations = self.studentInformations {
                        print(studentInformations.count)
                        self.tableView.reloadData()
                        // hide loading indicator
                    }
                case .failure(let error):
                    print(error) // extract error handling (show error & hide loading indicator)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
