//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

// MARK: StudentLocation

struct StudentLocation {
    
    // MARK: Properties
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: Int
    let updatedAt: String
    
    // MARK: Initializers
    // --- construct a studentlocation from a dictionary
    
    init(dictionary: [String:AnyObject]) {
        createdAt = dictionary[ParseClient.ResponseKeys.CreatedAt] as! String
        firstName = dictionary[ParseClient.ResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.ResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.ResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.ResponseKeys.Longitude] as! Double
        mapString = dictionary[ParseClient.ResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.ResponseKeys.MediaURL] as! String
        objectID = dictionary[ParseClient.ResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as! Int
        updatedAt = dictionary[ParseClient.ResponseKeys.UpdatedAt] as! String
    }
    
    static func studentsFromResults(_ results:[[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocation = [StudentLocation]()
        
        for result in results {
            studentLocation.append(StudentLocation(dictionary: result))
        }
        
        return studentLocation
    }
}
