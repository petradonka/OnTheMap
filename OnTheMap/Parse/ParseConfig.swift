//
//  ParseConfig.swift
//  OnTheMap
//
//  Created by Petra Donka on 24.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

struct ParseConfig {
    static let ApiBaseURL = "https://parse.udacity.com/parse/classes"
    static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    struct Headers {
        static let ApplicationId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    }

    struct StudentLocation {
        static let ClassName = "StudentLocation"

        struct JSONProperties {
            static let objectId = "objectId"
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let createdAt = "createdAt"
            static let updatedAt = "updatedAt"
            static let ACL = "ACL"
        }

        struct QueryKeys {
            static let limit = "limit"
            static let skip = "skip"
            static let order = "order"
        }
    }
}
