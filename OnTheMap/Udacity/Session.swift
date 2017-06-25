//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case requestError(String)
    case couldNotParseJSON
    case missingProperty(String)
    case apiError(String)
    case loginError(String)
}

struct Session {
    var sessionId: String
    var accountId: String
    
    static func session(forUsername username: String, andPassword password: String,
                        completion: @escaping (Result<Session, SessionError>) -> Void) {
        let body = [
            "udacity" : [
                "username" : username,
                "password" : password
            ]
        ]
        
        if let url = UdacityClient.getUrl(pathExtension: UdacityConfig.Session.PathExtension) {
            UdacityClient.post(url: url, body: body) { result in
                switch result {
                case .success(let jsonBody):
                    guard let json = jsonBody as? [String:[String:Any]] else {
                        if let errorJSON = jsonBody as? [String:Any],
                            let status = errorJSON["status"] as? Int,
                            status == 403,
                            let error = errorJSON["error"] as? String {
                            return completion(.failure(.loginError(error)))
                        } else {
                            return completion(.failure(.couldNotParseJSON))
                        }
                    }
                    
                    guard let sessionJSON = json[UdacityConfig.Session.JSONProperties.session] else {
                        return completion(.failure(.missingProperty("session")))
                    }
                    
                    guard let sessionId = sessionJSON[UdacityConfig.Session.JSONProperties.id] as? String else {
                        return completion(.failure(.missingProperty("session>id")))
                    }
                    
                    guard let accountJSON = json[UdacityConfig.Session.JSONProperties.account] else {
                        return completion(.failure(.missingProperty("account")))
                    }
                    
                    guard let accountId = accountJSON[UdacityConfig.Session.JSONProperties.key] as? String else {
                        return completion(.failure(.missingProperty("account>key")))
                    }
                    
                    let session = Session(sessionId: sessionId, accountId: accountId)
                    
                    completion(.success(session))
                    
                case .failure(let error):
                    switch error {
                    case .requestError(let error):
                        completion(.failure(.requestError(error)))
                    case .apiError(let error):
                        completion(.failure(.apiError(error)))
                    case .couldNotParseJSON:
                        completion(.failure(.couldNotParseJSON))
                    case .noData:
                        completion(.failure(.requestError("No data was returned")))
                    }
                }
            }
        }
    }
    
    func delete(completion: @escaping (Result<Void?, SessionError>) -> Void) {
        if let url = UdacityClient.getUrl(pathExtension: UdacityConfig.Session.PathExtension) {
            UdacityClient.delete(url: url, body: nil) { result in
                switch result {
                case .success(let jsonBody):
                    guard let json = jsonBody as? [String:[String:Any]] else {
                        return completion(.failure(.couldNotParseJSON))
                    }
                    
                    guard json[UdacityConfig.Session.JSONProperties.session] != nil else {
                        return completion(.failure(.missingProperty("session")))
                    }
                    
                    completion(.success(nil))
                case .failure(let error):
                    switch error {
                    case .apiError(let error), .requestError(let error):
                        completion(.failure(.requestError(error)))
                    case .couldNotParseJSON:
                        completion(.failure(.couldNotParseJSON))
                    case .noData:
                        completion(.failure(.requestError("No data was returned")))
                    }
                }
            }
        }
    }
}
