//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum ParseClientError: Error {
    case couldNotParseJSON
    case noData
    case apiError(String)
    case requestError(Error)
}

struct ParseClient {
    static func get(url: URL, completion: @escaping (Result<Any?, ParseClientError>) -> Void) {
        request(method: "GET", url: url, jsonBody: nil, completion: completion)
    }

    static func post(url: URL, body: Any?, completion: @escaping (Result<Any?, ParseClientError>) -> Void) {
        request(method: "POST", url: url, jsonBody: body, completion: completion)
    }

    static func put(url: URL, body: Any?, completion: @escaping (Result<Any?, ParseClientError>) -> Void) {
        request(method: "PUT", url: url, jsonBody: body, completion: completion)
    }

    static func request(method: String, url: URL, jsonBody: Any?,
                        completion: @escaping (Result<Any?, ParseClientError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method;
        request.addValue(ParseConfig.ApplicationId, forHTTPHeaderField: ParseConfig.Headers.ApplicationId)
        request.addValue(ParseConfig.ApiKey, forHTTPHeaderField: ParseConfig.Headers.ApiKey)

        if let json = jsonBody,
            let body = try? JSONSerialization.data(withJSONObject: json, options: []) {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil, response != nil else {
                return completion(Result.failure(ParseClientError.requestError(error!)))
            }

            guard let data = data else {
                return completion(Result.failure(ParseClientError.noData))
            }

            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                if let responseString = String.init(data: data, encoding: .utf8) {
                    return completion(Result.failure(ParseClientError.apiError(responseString)))
                } else {
                    return completion(Result.failure(ParseClientError.couldNotParseJSON))
                }
            }

            completion(Result.success(jsonData))
        }).resume()
    }

    static func urlForClass(_ className: String) -> URL? {
        var url = URLComponents.init(string: ParseConfig.ApiBaseURL)
        url?.path.append("/\(className)")
        return url?.url
    }

    static func urlForClass(_ className: String, withParams params: [String : String]) -> URL? {
        var url = URLComponents.init(string: ParseConfig.ApiBaseURL)
        url?.path.append("/\(className)")
        url?.queryItems = []
        for param in params {
            let queryItem = URLQueryItem(name: param.key, value: param.value)
            url?.queryItems?.append(queryItem)
        }
        return url?.url
    }
}
