//
//  User.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/22/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import Foundation
import MapKit

class User: NSObject {
    
    struct Information {
        
        static var CreatedAt = "createdAt"
        static var FirstName = "firstName"
        static var LastName = "lastName"
        static var Latitude: CLLocationDegrees = CLLocationDegrees()
        static var Longitude: CLLocationDegrees = CLLocationDegrees()
        static var MapString = "mapString"
        static var MediaURL = "mediaURL"
        static var ObjectID = "objectId"
        static var UniqueKey = "uniqueKey"
        static var UpdatedAt = "updatedAt"
        static var Results = "results"
        static var tempCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    }
    
}
