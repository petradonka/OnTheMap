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

    static let SignupURL = "https://www.udacity.com/account/auth#!/signup"

    struct Headers {
        static let XSRFToken = "X-XSRF-TOKEN"
    }

    struct Cookies {
        static let XSRFToken = "XSRF-TOKEN"
    }

    struct Session {
        static let PathExtension = "/session"

        struct JSONProperties {
            static let account = "account"
            static let key = "key" // User ID
            static let registered = "registered"

            static let session = "session"
            static let expiration = "expiration"
            static let id = "id" // Session ID
        }
    }

    struct Users {
        static let PathExtension = "/users"

        struct JSONProperties {
            static let user = "user"
            static let firstName = "first_name"
            static let lastName = "last_name"
            static let key = "key" // User ID
        }
    }
}
