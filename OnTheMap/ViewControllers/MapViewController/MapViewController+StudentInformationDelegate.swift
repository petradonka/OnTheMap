//
//  StudentInformationDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

extension MapViewController: StudentInformationDelegate {
    func refreshStudentInformations() {
        setupStudentInformations(andFetch: true) {}
    }

    func setupStudentInformations() {
        setupStudentInformations(andFetch: false) {}
    }

    func setupStudentInformations(andFetch shouldFetch: Bool, completion: @escaping () -> Void) {
        // show loading indicator
        if !shouldFetch, let studentInformations = studentInformations {
            print(studentInformations.count)
            completion()
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if let studentInformations = self.studentInformations {
                        print(studentInformations.count)
                        // hide loading indicator
                        DispatchQueue.main.async {
                            self.addStudentInformationsToMap(studentInformations: studentInformations)
                            completion()
                        }
                    }
                case .failure(let error):
                    print(error) // extract error handling (show error & hide loading indicator)
                }
            }
        }
    }
}
