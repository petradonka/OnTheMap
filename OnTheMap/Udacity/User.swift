//
//  User.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct User {
    let userId: String
    let firstName: String
    let lastName: String
    let session: Session

    func logout(completion: @escaping (Result<Void?, OnTheMapError>) -> Void) {
        session.delete(completion: completion)
    }

    static func user(withSession session: Session, completion: @escaping (Result<User, OnTheMapError>) -> Void) {
        if let url = getUrl(forUserId: session.accountId) {
            UdacityClient.get(url: url, completion: { result in
                switch result {
                case .success(let jsonBody):
                    guard let json = jsonBody as? [String:Any] else {
                        return completion(.failure(.couldNotParseJSON))
                    }

                    guard let userJSON = json[UdacityConfig.Users.JSONProperties.user] as? [String:Any] else {
                        return completion(.failure(.missingProperty("user")))
                    }

                    guard let firstName = userJSON[UdacityConfig.Users.JSONProperties.firstName] as? String else {
                        return completion(.failure(.noFirstName))
                    }

                    guard let lastName = userJSON[UdacityConfig.Users.JSONProperties.lastName] as? String else {
                        return completion(.failure(.noLastName))
                    }

                    let user = User(userId: session.accountId, firstName: firstName, lastName: lastName, session: session)

                    completion(.success(user))

                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }

    private static func getUrl(forUserId userId: String) -> URL? {
        let pathExtension = UdacityConfig.Users.PathExtension.appending("/\(userId)")
        return UdacityClient.getUrl(pathExtension: pathExtension)
    }
}
