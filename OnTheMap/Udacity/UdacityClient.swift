//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

enum UdacityClientError: Error {
    case couldNotParseJSON
    case noData
    case apiError(String)
    case requestError(String)
}

struct UdacityClient {
    static func get(url: URL, completion: @escaping (Result<Any?, UdacityClientError>) -> Void) {
        request(method: "GET", url: url, additionalHeaders: nil, jsonBody: nil, completion: completion)
    }

    static func post(url: URL, body: Any?, completion: @escaping (Result<Any?, UdacityClientError>) -> Void) {
        request(method: "POST", url: url, additionalHeaders: nil, jsonBody: body, completion: completion)
    }

    static func delete(url: URL, body: Any?, completion: @escaping (Result<Any?, UdacityClientError>) -> Void) {
        var additionalHeaders: [String : String] = [:]

        if let xsrfToken = getXSRFToken() {
            additionalHeaders[UdacityConfig.Headers.XSRFToken] = xsrfToken
        }

        request(method: "DELETE", url: url, additionalHeaders: additionalHeaders, jsonBody: body, completion: completion)
    }

    static func request(method: String, url: URL, additionalHeaders: [String : String]?, jsonBody: Any?,
                        completion: @escaping (Result<Any?, UdacityClientError>) -> Void) {
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
            guard error == nil, response != nil else {
                return completion(.failure(UdacityClientError.requestError(error!.localizedDescription)))
            }

            guard let data = data else {
                return completion(.failure(UdacityClientError.noData))
            }

            let range = Range(5..<data.count)
            let trimmedData = data.subdata(in: range)

            guard let jsonData = try? JSONSerialization.jsonObject(with: trimmedData, options: .allowFragments) else {
                if let responseString = String.init(data: data, encoding: .utf8) {
                    return completion(.failure(UdacityClientError.apiError(responseString)))
                } else {
                    return completion(.failure(UdacityClientError.couldNotParseJSON))
                }
            }

            completion(.success(jsonData))
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
