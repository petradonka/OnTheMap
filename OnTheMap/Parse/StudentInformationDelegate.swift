//
//  StudentInformationDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

protocol StudentInformationDelegate {
    var studentInformations: [StudentInformation]? { get }

    func fetchStudentInformations(completion: @escaping (Result<Void?, OnTheMapError>) -> Void)
}

extension StudentInformationDelegate {
    var studentInformations: [StudentInformation]? {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.studentInformations
            } else {
                return nil
            }
        }
    }

    func fetchStudentInformations(completion: @escaping (Result<Void?, OnTheMapError>) -> Void) {
        StudentInformation.studentLocations(limitTo: 100, skipping: 0, orderedBy: []) { (result) in
            switch result {
            case .success(let studentInformations):
                DispatchQueue.main.async {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.studentInformations = studentInformations
                        completion(.success(nil))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
