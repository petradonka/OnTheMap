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
        guard let parseId = json[ParseConfig.StudentLocation.JSONProperties.objectId] as? String else {
            print("could not parse objectId", json)
            return nil
        }

        guard let uniqueKey = json[ParseConfig.StudentLocation.JSONProperties.uniqueKey] as? String else {
            print("could not parse uniqueKey", json)
            return nil
        }

        guard let firstName = json[ParseConfig.StudentLocation.JSONProperties.firstName] as? String else {
            print("could not parse firstname", json)
            return nil
        }

        guard let lastName = json[ParseConfig.StudentLocation.JSONProperties.lastName] as? String else {
            print("could not parse lastname", json)
            return nil
        }

        guard let mapString = json[ParseConfig.StudentLocation.JSONProperties.mapString] as? String else {
            print("could not parse mapstring", json)
            return nil
        }

        guard let mediaURL = json[ParseConfig.StudentLocation.JSONProperties.mediaURL] as? String else {
            print("could not parse mediaurl", json)
            return nil
        }

        guard let latitude = json[ParseConfig.StudentLocation.JSONProperties.latitude] as? Double else {
            print("could not parse latitude", json)
            return nil
        }

        guard let longitude = json[ParseConfig.StudentLocation.JSONProperties.longitude] as? Double else {
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

    func toJSON() -> [String : Any] {
        return [
            ParseConfig.StudentLocation.JSONProperties.uniqueKey: udacityUserId,
            ParseConfig.StudentLocation.JSONProperties.firstName: firstName,
            ParseConfig.StudentLocation.JSONProperties.lastName: lastName,
            ParseConfig.StudentLocation.JSONProperties.mapString: mapString,
            ParseConfig.StudentLocation.JSONProperties.mediaURL: mediaURL,
            ParseConfig.StudentLocation.JSONProperties.latitude: latitude,
            ParseConfig.StudentLocation.JSONProperties.longitude: longitude
            ] as [String : Any]
    }
}

// MARK: - ParseClient convenience methods

extension StudentLocation {
    static func studentLocations(limitTo limit: Int, skipping skip: Int, orderedBy order: [String], completion: @escaping ([StudentLocation]) -> Void) {
        let queryParams: [String : String] = [
            ParseConfig.StudentLocation.QueryKeys.limit: String(limit),
            ParseConfig.StudentLocation.QueryKeys.skip: String(skip),
            ParseConfig.StudentLocation.QueryKeys.order: order.joined(separator: ","),
            ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url, completion: { jsonData in
                guard let json = jsonData as? [String : AnyObject],
                    let results = json["results"] as? [[String : AnyObject]] else {
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
            "where": "{\"\(ParseConfig.StudentLocation.JSONProperties.uniqueKey)\":\"\(id)\"}"
        ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url, completion: { jsonData in
                guard let json = jsonData as? [String : AnyObject],
                    let results = json["results"] as? [[String : AnyObject]] else {
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

    func save(completion: @escaping () -> Void) {
        StudentLocation.studentLocation(forUserId: udacityUserId) { studentLocation in
            if let studentLocation = studentLocation {                                      // student location already exists for the user
                self.update(existingLocation: studentLocation, completion: completion)
            } else {                                                                        // nothing exists yet
                self.send(completion: completion)
            }
        }
    }

    func send(completion: @escaping () -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName) {
            ParseClient.post(url: url, body: body, completion: { jsonData in
                guard let json = jsonData as? [String : String],
                    json[ParseConfig.StudentLocation.JSONProperties.objectId] != nil,
                    json[ParseConfig.StudentLocation.JSONProperties.createdAt] != nil else {
                        print("something went wrong...")
                        return
                }

                completion()
            })
        }
    }

    func update(existingLocation: StudentLocation, completion: @escaping () -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName) {
            var newUrl = URLComponents(url: url, resolvingAgainstBaseURL: false)
            newUrl?.path.append("/\(parseId)")

            if let newUrl = newUrl?.url {
                ParseClient.put(url: newUrl, body: body, completion: { jsonData in
                    guard let json = jsonData as? [String : String],
                        json[ParseConfig.StudentLocation.JSONProperties.updatedAt] != nil else {
                            print("something went wrong...")
                            return
                    }

                    completion()
                })
            }
        }
    }
}
