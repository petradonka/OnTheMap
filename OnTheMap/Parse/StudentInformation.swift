//
//  StudentInformation
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

class StudentInformations {
    static let sharedInstance = StudentInformations()

    var studentInformations: [StudentInformation] = []

    var sortedStudentInformations: [StudentInformation] {
        get {
            return studentInformations.sorted(by: { $0.updatedAt > $1.updatedAt })
        }
    }
}

struct StudentInformation {
    let parseId: String?
    let udacityUserId: String
    let firstName: String
    let lastName: String
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    let updatedAt: Date

    init(json: [String:AnyObject]) throws {
        guard let parseId = json[ParseConfig.StudentInformation.JSONProperties.objectId] as? String else {
            throw OnTheMapError.missingProperty("objectId")
        }

        guard let uniqueKey = json[ParseConfig.StudentInformation.JSONProperties.uniqueKey] as? String else {
            throw OnTheMapError.missingProperty("uniqieKey")
        }

        guard let firstName = json[ParseConfig.StudentInformation.JSONProperties.firstName] as? String else {
            throw OnTheMapError.missingProperty("firstName")
        }

        guard let lastName = json[ParseConfig.StudentInformation.JSONProperties.lastName] as? String else {
            throw OnTheMapError.missingProperty("lastName")
        }

        guard let mapString = json[ParseConfig.StudentInformation.JSONProperties.mapString] as? String else {
            throw OnTheMapError.missingProperty("mapString")
        }

        guard let mediaURL = json[ParseConfig.StudentInformation.JSONProperties.mediaURL] as? String else {
            throw OnTheMapError.missingProperty("mediaURL")
        }

        guard let latitude = json[ParseConfig.StudentInformation.JSONProperties.latitude] as? Double else {
            throw OnTheMapError.missingProperty("latitude")
        }

        guard let longitude = json[ParseConfig.StudentInformation.JSONProperties.longitude] as? Double else {
            throw OnTheMapError.missingProperty("longitude")
        }

        guard let updatedAtString = json[ParseConfig.StudentInformation.JSONProperties.updatedAt] as? String else {
            throw OnTheMapError.missingProperty("updatedAt")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"

        guard let updatedAt = dateFormatter.date(from: updatedAtString) else {
            throw OnTheMapError.couldNotParseJSON
        }

        self.parseId = parseId
        self.udacityUserId = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.updatedAt = updatedAt
    }

    init(udacityUserId: String, firstName: String, lastName: String) {
        self.udacityUserId = udacityUserId
        self.firstName = firstName
        self.lastName = lastName

        self.updatedAt = Date()
        self.parseId = nil
        self.mapString = nil
        self.latitude = nil
        self.longitude = nil
        self.mediaURL = nil
    }

    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }

    func toJSON() -> [String : Any] {
        var base = [ParseConfig.StudentInformation.JSONProperties.uniqueKey: udacityUserId,
                    ParseConfig.StudentInformation.JSONProperties.firstName: firstName,
                    ParseConfig.StudentInformation.JSONProperties.lastName: lastName] as [String : Any]

        if let mapString = mapString {
            base[ParseConfig.StudentInformation.JSONProperties.mapString] = mapString
        }

        if let mediaURL = mediaURL {
            base[ParseConfig.StudentInformation.JSONProperties.mediaURL] = mediaURL
        }

        if let latitude = latitude, let longitude = longitude {
            base[ParseConfig.StudentInformation.JSONProperties.latitude] = latitude
            base[ParseConfig.StudentInformation.JSONProperties.longitude] = longitude
        }

        return base
    }
}
