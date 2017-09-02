//
//  ListTableViewController+StudentInformationDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 26.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

extension ListTableViewController: StudentInformationDelegate {

    var studentInformations: [StudentInformation]? {
        get {
            return StudentInformations.sharedInstance.studentInformations.sorted(by: { $0.updatedAt > $1.updatedAt })
        }
    }
    
    func setupStudentInformations(andFetch shouldFetch: Bool = false, complete: @escaping () -> Void) {
        if !shouldFetch, (studentInformations != nil) {
            complete()
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if (self.studentInformations != nil) {
                        DispatchQueue.main.async {
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
