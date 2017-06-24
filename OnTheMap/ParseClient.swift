//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct ParseClient {
    static func get(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        request(method: "GET", url: url, completionHandler: completionHandler)
    }

    static func post(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        request(method: "POST", url: url, completionHandler: completionHandler)
    }

    static func put(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        request(method: "PUT", url: url, completionHandler: completionHandler)
    }

    static func request(method: String, url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue(ParseConfig.ApplicationId, forHTTPHeaderField: ParseConfig.Headers.ApplicationId)
        request.addValue(ParseConfig.ApiKey, forHTTPHeaderField: ParseConfig.Headers.ApiKey)

        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }

    static func urlForClass(_ className: String) -> URL? {
        var url = URLComponents.init(string: ParseConfig.ApiBaseURL)
        url?.path.append("/\(className)")
        return url?.url
    }

    static func urlForClass(_ className: String, withParams params: [String:String]) -> URL? {
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
