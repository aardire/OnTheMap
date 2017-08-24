//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/10/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: keys
        static let RESTApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"

        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
        static let WherePath = "(objectID)"+"uniqueKey"+"(UniqueKey)"
    }
    
    // MARK: Response Keys
    struct ResponseKeys {
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        static let Results = "results"
    }
    
    // MARK: Methods
    struct Parameters {
        static let Limit = "limit"
        static let Where = "where"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    struct Methods {
        static let PutStudent = "/<objectId>"
        static let UpdatedAt = "-updatedAt"
    }
    
    
}
