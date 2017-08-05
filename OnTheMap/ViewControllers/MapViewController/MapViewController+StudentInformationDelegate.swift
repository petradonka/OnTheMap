//
//  StudentInformationDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

extension MapViewController: StudentInformationDelegate {
    func refreshStudentInformations(complete: @escaping () -> Void) {
        setupStudentInformations(andFetch: true, complete: complete)
    }

    func setupStudentInformations() {
        setupStudentInformations(andFetch: false) {}
    }

    func setupStudentInformations(andFetch shouldFetch: Bool, complete: @escaping () -> Void) {
        if !shouldFetch, (studentInformations != nil) {
            complete()
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if let studentInformations = self.studentInformations  {
                        DispatchQueue.main.async {
                            self.addStudentInformationsToMap(studentInformations: studentInformations)
                            complete()
                        }
                    }
                case .failure(let error):
                    print(error) // extract error handling
                    complete()
                }
            }
        }
    }
}
