//
//  StudentInformation
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum StudentInformationError: Error {
    case missingProperty(String)
    case couldNotParseJSON
    case noResults
    case requestError(ParseClientError)
}

struct StudentInformation {
    let parseId: String
    let udacityUserId: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    init(json: [String:AnyObject]) throws {
        guard let parseId = json[ParseConfig.StudentInformation.JSONProperties.objectId] as? String else {
            throw StudentInformationError.missingProperty("objectId")
        }

        guard let uniqueKey = json[ParseConfig.StudentInformation.JSONProperties.uniqueKey] as? String else {
            throw StudentInformationError.missingProperty("uniqieKey")
        }

        guard let firstName = json[ParseConfig.StudentInformation.JSONProperties.firstName] as? String else {
            throw StudentInformationError.missingProperty("firstName")
        }

        guard let lastName = json[ParseConfig.StudentInformation.JSONProperties.lastName] as? String else {
            throw StudentInformationError.missingProperty("lastName")
        }

        guard let mapString = json[ParseConfig.StudentInformation.JSONProperties.mapString] as? String else {
            throw StudentInformationError.missingProperty("mapString")
        }

        guard let mediaURL = json[ParseConfig.StudentInformation.JSONProperties.mediaURL] as? String else {
            throw StudentInformationError.missingProperty("mediaURL")
        }

        guard let latitude = json[ParseConfig.StudentInformation.JSONProperties.latitude] as? Double else {
            throw StudentInformationError.missingProperty("latitude")
        }

        guard let longitude = json[ParseConfig.StudentInformation.JSONProperties.longitude] as? Double else {
            throw StudentInformationError.missingProperty("objectId")
        }

        self.parseId = parseId
        self.udacityUserId = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }

    func toJSON() -> [String : Any] {
        return [
            ParseConfig.StudentInformation.JSONProperties.uniqueKey: udacityUserId,
            ParseConfig.StudentInformation.JSONProperties.firstName: firstName,
            ParseConfig.StudentInformation.JSONProperties.lastName: lastName,
            ParseConfig.StudentInformation.JSONProperties.mapString: mapString,
            ParseConfig.StudentInformation.JSONProperties.mediaURL: mediaURL,
            ParseConfig.StudentInformation.JSONProperties.latitude: latitude,
            ParseConfig.StudentInformation.JSONProperties.longitude: longitude
            ] as [String : Any]
    }
}
