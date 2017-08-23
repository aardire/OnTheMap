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
    let uniqueKey: String
    let updatedAt: String
    
    // MARK: Initializers
    // --- construct a studentlocation from a dictionary
    
    init(dictionary: [String:Any]) {
        
        if let createdAtDict = dictionary[ParseClient.ResponseKeys.CreatedAt]  {
            self.createdAt = createdAtDict as! String
        } else {
            self.createdAt = ""
        }
        
        if let firstNameDict = dictionary[ParseClient.ResponseKeys.FirstName]  {
            self.firstName = firstNameDict as! String
        } else {
            self.firstName = ""
        }
        
        if let lastNameDict = dictionary[ParseClient.ResponseKeys.LastName] {
            self.lastName = lastNameDict as! String
        } else {
            self.lastName = ""
        }
        
        if let latitudeDict = dictionary[ParseClient.ResponseKeys.Latitude] {
            self.latitude = latitudeDict as! Double
        } else {
            self.latitude = 0.0
        }
        
        if let longitudeDict = dictionary[ParseClient.ResponseKeys.Longitude] {
            self.longitude = longitudeDict as! Double
        } else {
            self.longitude = 0.0
        }
        
        if let mapStringDict = dictionary[ParseClient.ResponseKeys.MapString] {
            self.mapString = mapStringDict as! String
        } else {
            self.mapString = ""
        }
        
        if let mediaURLDict = dictionary[ParseClient.ResponseKeys.MediaURL] {
           self.mediaURL = mediaURLDict as! String
        } else {
            self.mediaURL = ""
        }
        
        if let objectIDDict = dictionary[ParseClient.ResponseKeys.ObjectID] {
            self.objectID = objectIDDict as! String
        } else {
            self.objectID = ""
        }
        
        if let uniqueKeyDict = dictionary[ParseClient.ResponseKeys.UniqueKey] {
            self.uniqueKey = uniqueKeyDict as! String
        } else {
            self.uniqueKey = ""
        }
        
        if let updatedAtDict = dictionary[ParseClient.ResponseKeys.UpdatedAt] {
            self.updatedAt = updatedAtDict as! String
        } else {
            self.updatedAt = ""
        }
        
    }
    
    
    static func studentsFromResults(_ results:[[String:Any]]) -> [StudentLocation] {
        
        var studentLocation = [StudentLocation]()
        
        for result in results {
            studentLocation.append(StudentLocation(dictionary: result))
        }
        
        return studentLocation
    }
   
}
