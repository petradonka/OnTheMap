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
        if !shouldFetch, let studentInformations = studentInformations {
            self.addStudentInformationsToMap(shouldClear: true, studentInformations: studentInformations)
            complete()
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if let studentInformations = self.studentInformations  {
                        DispatchQueue.main.async {
                            self.addStudentInformationsToMap(shouldClear: true, studentInformations: studentInformations)
                            complete()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.handleError(error)
                        complete()
                    }
                }
            }
        }
    }
}
