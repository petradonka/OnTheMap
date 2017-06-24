//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct StudentLocation {
    let parseId: String
    let udacityUserId: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    init?(json: [String:AnyObject]) {
        guard let parseId = json[ParseConfig.StudentLocation.FieldNames.objectId] as? String else {
            print("could not parse objectId", json)
            return nil
        }

        guard let uniqueKey = json[ParseConfig.StudentLocation.FieldNames.uniqueKey] as? String else {
            print("could not parse uniqueKey", json)
            return nil
        }

        guard let firstName = json[ParseConfig.StudentLocation.FieldNames.firstName] as? String else {
            print("could not parse firstname", json)
            return nil
        }

        guard let lastName = json[ParseConfig.StudentLocation.FieldNames.lastName] as? String else {
            print("could not parse lastname", json)
            return nil
        }

        guard let mapString = json[ParseConfig.StudentLocation.FieldNames.mapString] as? String else {
            print("could not parse mapstring", json)
            return nil
        }

        guard let mediaURL = json[ParseConfig.StudentLocation.FieldNames.mediaURL] as? String else {
            print("could not parse mediaurl", json)
            return nil
        }

        guard let latitude = json[ParseConfig.StudentLocation.FieldNames.latitude] as? Double else {
            print("could not parse latitude", json)
            return nil
        }

        guard let longitude = json[ParseConfig.StudentLocation.FieldNames.longitude] as? Double else {
            print("could not parse longitude", json)
            return nil
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
}

// MARK: - ParseClient convenience methods

extension StudentLocation {
    static func studentLocations(limitTo limit: Int, skipping skip: Int, orderedBy order: [String], completion: @escaping ([StudentLocation]) -> Void) {
        let queryParams: [String:String] = [
            ParseConfig.StudentLocation.QueryKeys.limit: String(limit),
            ParseConfig.StudentLocation.QueryKeys.skip: String(skip),
            ParseConfig.StudentLocation.QueryKeys.order: order.joined(separator: ","),
        ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url, completionHandler: { (data, response, error) in
                guard error == nil,
                    response != nil,
                    let data = data else {
                        print("something went wrong!")
                        if let error = error {
                            print(error)
                        }
                        return
                }

                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let json = jsonData as? [String:AnyObject],
                    let results = json["results"] as? [[String:AnyObject]] else {
                        print("could not parse data")
                        return
                }

                var studentLocations: [StudentLocation] = []

                for result in results {
                    if let studentLocation = StudentLocation(json: result) {
                        studentLocations.append(studentLocation)
                    }
                }

                completion(studentLocations)
            })
        }
    }

    static func studentLocation(forUserId id: String, completion: @escaping (StudentLocation?) -> Void) {
        let queryParams = [
            "where": "{\"\(ParseConfig.StudentLocation.FieldNames.uniqueKey)\":\"\(id)\"}"
        ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url, completionHandler: { (data, response, error) in
                guard error == nil,
                    response != nil,
                    let data = data else {
                        print("something went wrong!")
                        if let error = error {
                            print(error)
                        }
                        return
                }

                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let json = jsonData as? [String:AnyObject],
                    let results = json["results"] as? [[String:AnyObject]] else {
                        print("could not parse data")
                        return
                }

                var studentLocations: [StudentLocation] = []

                for result in results {
                    if let studentLocation = StudentLocation(json: result) {
                        studentLocations.append(studentLocation)
                    }
                }

                completion(studentLocations.first)
            })
        }
    }
}
