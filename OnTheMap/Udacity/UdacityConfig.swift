//
//  UdacityConfig.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

struct UdacityConfig {
    static let ApiBaseURL = "https://www.udacity.com/api"

    struct Headers {
        static let XSRFToken = "X-XSRF-TOKEN"
    }

    struct Cookies {
        static let XSRFToken = "XSRF-TOKEN"
    }

    struct Session {
        static let PathExtention = "/session"

        struct JSONProperties {
            static let account = "account"
            static let key = "key"
            static let registered = "registered"

            static let session = "session"
            static let expiration = "expiration"
            static let id = "id"
        }
    }

    struct Users {
        static let PathExtension = "/users"

        struct JSONProperties {
            static let user = "user"
            static let firstName = "first_name"
            static let lastName = "last_name"
        }
    }
}
