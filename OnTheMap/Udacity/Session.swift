//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct Session {
    var sessionId: String
    var accountId: String

    static func session(forUsername username: String, andPassword password: String,
                        completion: @escaping (Session) -> Void) {
        let body = [
            "udacity" : [
                "username" : username,
                "password" : password
            ]
        ]

        if let url = UdacityClient.getUrl(pathExtension: UdacityConfig.Session.PathExtension) {
            UdacityClient.post(url: url, body: body, completion: { (jsonBody) in
                guard let json = jsonBody as? [String:[String:Any]] else {
                    print("json was corrupted", jsonBody ?? "no jsonBody")
                    return
                }

                guard let session = json[UdacityConfig.Session.JSONProperties.session],
                    let sessionId = session[UdacityConfig.Session.JSONProperties.id] as? String,
                    let account = json[UdacityConfig.Session.JSONProperties.account],
                    let accountId = account[UdacityConfig.Session.JSONProperties.key] as? String else {
                        print("session creation was not successful", json)
                        return
                }

                completion(Session(sessionId: sessionId, accountId: accountId))
            })
        }
    }

    func delete(completion: @escaping () -> Void) {
        if let url = UdacityClient.getUrl(pathExtension: UdacityConfig.Session.PathExtension) {
            UdacityClient.delete(url: url, body: nil, completion: { jsonBody in
                guard let json = jsonBody as? [String:[String:Any]],
                    json[UdacityConfig.Session.JSONProperties.session] != nil else {
                        print("json was corrupted", jsonBody ?? "no jsonBody")
                        return
                }
                
                completion()
            })
        }
    }
    
}
