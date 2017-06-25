//
//  OnTheMapError.swift
//  OnTheMap
//
//  Created by Petra Donka on 25.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum OnTheMapError: Error {
    // JSON related errors
    case couldNotParseJSON
    case missingProperty(String)

    // Request related errors
    case noData
    case apiError(String)
    case requestError(String)

    // Specific errors
    case noResults
    case loginError(String)
    case noFirstName
    case noLastName
}
