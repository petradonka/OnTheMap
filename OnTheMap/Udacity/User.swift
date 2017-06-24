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

    func logout(completion: @escaping () -> Void) {
        session.delete(completion: completion)
    }

    static func user(withSession session: Session, completion: @escaping (User) -> Void) {
        if let url = getUrl(forUserId: session.accountId) {
            UdacityClient.get(url: url, completion: { jsonBody in
                guard let json = jsonBody as? [String:Any],
                    let user = json[UdacityConfig.Users.JSONProperties.user] as? [String:Any] else {
                        print("something went wrong, no user?")
                        return
                }

                guard let firstName = user[UdacityConfig.Users.JSONProperties.firstName] as? String,
                    let lastName = user[UdacityConfig.Users.JSONProperties.lastName] as? String else {
                        print("the user did not have a first or last name")
                        return
                }

                completion(User(userId: session.accountId, firstName: firstName, lastName: lastName, session: session))
            })
        }
    }

    private static func getUrl(forUserId userId: String) -> URL? {
        let pathExtension = UdacityConfig.Users.PathExtension.appending("/\(userId)")
        return UdacityClient.getUrl(pathExtension: pathExtension)
    }
}
