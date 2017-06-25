//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum StudentLocationError: Error {
    case missingProperty(String)
    case couldNotParseJSON
    case noResults
    case requestError(ParseClientError)
}

struct StudentLocation {
    let parseId: String
    let udacityUserId: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    init(json: [String:AnyObject]) throws {
        guard let parseId = json[ParseConfig.StudentLocation.JSONProperties.objectId] as? String else {
            throw StudentLocationError.missingProperty("objectId")
        }

        guard let uniqueKey = json[ParseConfig.StudentLocation.JSONProperties.uniqueKey] as? String else {
            throw StudentLocationError.missingProperty("uniqieKey")
        }

        guard let firstName = json[ParseConfig.StudentLocation.JSONProperties.firstName] as? String else {
            throw StudentLocationError.missingProperty("firstName")
        }

        guard let lastName = json[ParseConfig.StudentLocation.JSONProperties.lastName] as? String else {
            throw StudentLocationError.missingProperty("lastName")
        }

        guard let mapString = json[ParseConfig.StudentLocation.JSONProperties.mapString] as? String else {
            throw StudentLocationError.missingProperty("mapString")
        }

        guard let mediaURL = json[ParseConfig.StudentLocation.JSONProperties.mediaURL] as? String else {
            throw StudentLocationError.missingProperty("mediaURL")
        }

        guard let latitude = json[ParseConfig.StudentLocation.JSONProperties.latitude] as? Double else {
            throw StudentLocationError.missingProperty("latitude")
        }

        guard let longitude = json[ParseConfig.StudentLocation.JSONProperties.longitude] as? Double else {
            throw StudentLocationError.missingProperty("objectId")
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
    static func studentLocations(limitTo limit: Int, skipping skip: Int, orderedBy order: [String],
                                 completion: @escaping (Result<[StudentLocation], StudentLocationError>) -> Void) {
        let queryParams: [String : String] = [
            ParseConfig.StudentLocation.QueryKeys.limit: String(limit),
            ParseConfig.StudentLocation.QueryKeys.skip: String(skip),
            ParseConfig.StudentLocation.QueryKeys.order: order.joined(separator: ","),
            ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : AnyObject] else {
                        return completion(.failure(StudentLocationError.couldNotParseJSON))
                    }

                    guard let results = json["results"] as? [[String : AnyObject]] else {
                        return completion(.failure(StudentLocationError.missingProperty("results")))
                    }

                    guard results.count > 0 else {
                        return completion(.failure(StudentLocationError.noResults))
                    }

                    var studentLocations: [StudentLocation] = []

                    for result in results {
                        if let studentLocation = try? StudentLocation(json: result) {
                            studentLocations.append(studentLocation)
                        }
                    }

                    completion(.success(studentLocations))
                case .failure(let error):
                    completion(.failure(StudentLocationError.requestError(error)))
                }
            }
        }
    }

    static func studentLocation(forUserId id: String,
                                completion: @escaping (Result<StudentLocation, StudentLocationError>) -> Void) {
        let queryParams = [
            "where": "{\"\(ParseConfig.StudentLocation.JSONProperties.uniqueKey)\":\"\(id)\"}"
        ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : AnyObject] else {
                        return completion(.failure(StudentLocationError.couldNotParseJSON))
                    }

                    guard let results = json["results"] as? [[String : AnyObject]] else {
                        return completion(.failure(StudentLocationError.missingProperty("results")))
                    }

                    guard results.count > 0, let firstResult = results.first else {
                        return completion(.failure(StudentLocationError.noResults))
                    }

                    do {
                        let studentLocation = try StudentLocation(json: firstResult)
                        completion(.success(studentLocation))
                    } catch StudentLocationError.missingProperty(let property) {
                        completion(.failure(StudentLocationError.missingProperty(property)))
                    } catch {
                        print(error)
                        return
                    }
                case .failure(let error):
                    completion(.failure(StudentLocationError.requestError(error)))
                }
            }
        }
    }

    func save(completion: @escaping (Result<Void?, StudentLocationError>) -> Void) {
        StudentLocation.studentLocation(forUserId: udacityUserId) { result in
            switch result {
            case .success(let studentLocation):
                self.update(existingLocation: studentLocation, completion: completion)

            case .failure(StudentLocationError.noResults):
                self.send(completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func send(completion: @escaping (Result<Void?, StudentLocationError>) -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName) {
            ParseClient.post(url: url, body: body) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : String] else {
                        return completion(.failure(StudentLocationError.couldNotParseJSON))
                    }

                    guard json[ParseConfig.StudentLocation.JSONProperties.objectId] != nil else {
                        return completion(.failure(StudentLocationError.missingProperty("objectId")))
                    }

                    guard json[ParseConfig.StudentLocation.JSONProperties.createdAt] != nil else {
                        return completion(.failure(StudentLocationError.missingProperty("createdAt")))
                    }

                    completion(.success(nil))
                case .failure(let error):
                    completion(.failure(StudentLocationError.requestError(error)))
                }
            }
        }
    }

    func update(existingLocation: StudentLocation, completion: @escaping (Result<Void?, StudentLocationError>) -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentLocation.ClassName) {
            var newUrl = URLComponents(url: url, resolvingAgainstBaseURL: false)
            newUrl?.path.append("/\(parseId)")

            if let newUrl = newUrl?.url {
                ParseClient.put(url: newUrl, body: body) { result in
                    switch result {
                    case .success(let jsonData):
                        guard let json = jsonData as? [String : String] else {
                            return completion(.failure(StudentLocationError.couldNotParseJSON))
                        }

                        guard json[ParseConfig.StudentLocation.JSONProperties.updatedAt] != nil else {
                            return completion(.failure(StudentLocationError.missingProperty("updatedAt")))
                        }

                        completion(.success(nil))
                    case .failure(let error):
                        completion(.failure(StudentLocationError.requestError(error)))
                    }
                }
            }
        }
    }
}
