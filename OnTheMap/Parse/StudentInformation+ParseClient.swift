//
//  StudentInformation+ParseClient.swift
//  OnTheMap
//
//  Created by Petra Donka on 25.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

// MARK: - ParseClient convenience methods

extension StudentInformation {
    static func studentLocations(limitTo limit: Int, skipping skip: Int, orderedBy order: [String],
                                 completion: @escaping (Result<[StudentInformation], OnTheMapError>) -> Void) {
        let queryParams: [String : String] = [
            ParseConfig.StudentInformation.QueryKeys.limit: String(limit),
            ParseConfig.StudentInformation.QueryKeys.skip: String(skip),
            ParseConfig.StudentInformation.QueryKeys.order: order.joined(separator: ","),
            ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentInformation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : AnyObject] else {
                        return completion(.failure(.couldNotParseJSON))
                    }

                    guard let results = json["results"] as? [[String : AnyObject]] else {
                        return completion(.failure(.missingProperty("results")))
                    }

                    guard results.count > 0 else {
                        return completion(.failure(.noResults))
                    }

                    var studentLocations: [StudentInformation] = []

                    for result in results {
                        if let studentLocation = try? StudentInformation(json: result) {
                            studentLocations.append(studentLocation)
                        }
                    }

                    completion(.success(studentLocations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    static func studentLocation(forUserId id: String,
                                completion: @escaping (Result<StudentInformation, OnTheMapError>) -> Void) {
        let queryParams = [
            "where": "{\"\(ParseConfig.StudentInformation.JSONProperties.uniqueKey)\":\"\(id)\"}"
        ]

        if let url = ParseClient.urlForClass(ParseConfig.StudentInformation.ClassName, withParams: queryParams) {
            ParseClient.get(url: url) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : AnyObject] else {
                        return completion(.failure(.couldNotParseJSON))
                    }

                    guard let results = json["results"] as? [[String : AnyObject]] else {
                        return completion(.failure(.missingProperty("results")))
                    }

                    guard results.count > 0, let firstResult = results.first else {
                        return completion(.failure(.noResults))
                    }

                    do {
                        let studentLocation = try StudentInformation(json: firstResult)
                        completion(.success(studentLocation))
                    } catch OnTheMapError.missingProperty(let property) {
                        completion(.failure(.missingProperty(property)))
                    } catch {
                        print(error)
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func save(completion: @escaping (Result<Void?, OnTheMapError>) -> Void) {
        StudentInformation.studentLocation(forUserId: udacityUserId) { result in
            switch result {
            case .success(let studentLocation):
                self.update(existingLocation: studentLocation, completion: completion)

            case .failure(.noResults):
                self.send(completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func send(completion: @escaping (Result<Void?, OnTheMapError>) -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentInformation.ClassName) {
            ParseClient.post(url: url, body: body) { result in
                switch result {
                case .success(let jsonData):
                    guard let json = jsonData as? [String : String] else {
                        return completion(.failure(.couldNotParseJSON))
                    }

                    guard json[ParseConfig.StudentInformation.JSONProperties.objectId] != nil else {
                        return completion(.failure(.missingProperty("objectId")))
                    }

                    guard json[ParseConfig.StudentInformation.JSONProperties.createdAt] != nil else {
                        return completion(.failure(.missingProperty("createdAt")))
                    }

                    completion(.success(nil))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    fileprivate func update(existingLocation: StudentInformation, completion: @escaping (Result<Void?, OnTheMapError>) -> Void) {
        let body = toJSON()

        if let url = ParseClient.urlForClass(ParseConfig.StudentInformation.ClassName),
            let parseId = parseId {
            var newUrl = URLComponents(url: url, resolvingAgainstBaseURL: false)
            newUrl?.path.append("/\(parseId)")

            if let newUrl = newUrl?.url {
                ParseClient.put(url: newUrl, body: body) { result in
                    switch result {
                    case .success(let jsonData):
                        guard let json = jsonData as? [String : String] else {
                            return completion(.failure(.couldNotParseJSON))
                        }

                        guard json[ParseConfig.StudentInformation.JSONProperties.updatedAt] != nil else {
                            return completion(.failure(.missingProperty("updatedAt")))
                        }

                        completion(.success(nil))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } else {
            print("no parseID?")
        }
    }
}
