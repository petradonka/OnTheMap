//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct UdacityClient {
    static func post(url: URL, body: Any?, completion: @escaping (Any?) -> Void) {
        request(method: "POST", url: url, additionalHeaders: nil, jsonBody: body, completion: completion)
    }

    static func delete(url: URL, body: Any?, completion: @escaping (Any?) -> Void) {
        var additionalHeaders: [String : String] = [:]

        if let xsrfToken = getXSRFToken() {
            additionalHeaders[UdacityConfig.Headers.XSRFToken] = xsrfToken
        }

        request(method: "DELETE", url: url, additionalHeaders: additionalHeaders, jsonBody: body, completion: completion)
    }

    static func request(method: String, url: URL, additionalHeaders: [String : String]?, jsonBody: Any?,
                        completion: @escaping (Any?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let json = jsonBody,
            let body = try? JSONSerialization.data(withJSONObject: json, options: []) {
            request.httpBody = body
        }

        if let additionalHeaders = additionalHeaders {
            for case let header in additionalHeaders {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        let session = URLSession.shared

        session.dataTask(with: request) { data, response, error in
            guard error == nil,
                response != nil,
                let data = data else {
                    print("something went wrong!")
                    if let error = error {
                        print(error)
                    }
                    return
            }

            let range = Range(5..<data.count)
            let trimmedData = data.subdata(in: range)

            guard let jsonData = try? JSONSerialization.jsonObject(with: trimmedData, options: .allowFragments) else {
                print("could not parse json")
                if let responseString = String.init(data: data, encoding: .utf8) {
                    print(responseString) // potential error message
                }
                return
            }

            completion(jsonData)
        }.resume()
    }

    static func getUrl(pathExtension: String) -> URL? {
        var url = URLComponents(string: UdacityConfig.ApiBaseURL)
        url?.path.append("\(pathExtension)")
        return url?.url
    }

    private static func getXSRFToken() -> String? {
        var xsrfCookie: HTTPCookie? = nil

        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == UdacityConfig.Cookies.XSRFToken {
                    xsrfCookie = cookie
                }
            }
        }

        if let xsrfCookie = xsrfCookie {
            return xsrfCookie.value
        } else {
            return nil
        }
    }
}
