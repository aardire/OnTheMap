//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

// MARK: ParseClient (Convenient Resource Methods)

extension ParseClient {
    
    
    private func getAllStudentLocations(_ numOfStudents: Int, completionHandlerForStudentLocations: @escaping (_ success: Bool?,_ error: NSError?, _ results:[[String:AnyObject]]?) -> Void ) {
        
        /* Specify Parameters for taskforGet */
        var parameters = [String: Any]()
        parameters[ParseClient.Parameters.Limit] = numOfStudents
        parameters[ParseClient.Parameters.Order] = ParseClient.Methods.UpdatedAt
        
        let _ = taskForGetMethod(parameters) { (studentLocations, error) in
            
            if let error = error {
                completionHandlerForStudentLocations(nil,error,nil)
            } else {
                if let results = studentLocations?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] {
                    completionHandlerForStudentLocations(true,nil,results)
                } else {
                    completionHandlerForStudentLocations(nil,NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]),nil)
                }
            }
        }
    }
    
    func returnStudents(_ number: Int, _ completionHandlerForStudents: @escaping (_ success: Bool) -> Void) {
        
        getAllStudentLocations(number) { (success, error, results) in
            if error != nil {
            completionHandlerForStudents(false)
            } else {
                StudentData.locationArray = StudentLocation.studentsFromResults(results!)
                completionHandlerForStudents(true)
            }
        }

    }
    
}
