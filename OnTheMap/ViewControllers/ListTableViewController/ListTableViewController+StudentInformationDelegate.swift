//
//  ListTableViewController+StudentInformationDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 26.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

extension ListTableViewController: StudentInformationDelegate {
    var studentInformations: [StudentInformation]? {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.studentInformations?.sorted(by: { $0.updatedAt > $1.updatedAt })
            } else {
                return nil
            }
        }
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
}
