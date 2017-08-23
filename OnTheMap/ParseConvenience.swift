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
    
    
    private func getAllStudentLocations(_ numOfStudents: Int, completionHandlerForStudentLocations: @escaping (_ success: Bool?,_ error: NSError?) -> Void ) {
        
        /* Specify Parameters for taskforGet */
        var parameters = [String: Any]()
        parameters[ParseClient.Parameters.Limit] = numOfStudents
        
        let _ = taskForGetMethod(parameters) { (studentLocations, error) in
            
            if let error = error {
                print(error)
                completionHandlerForStudentLocations(nil,error)
            } else {
                if let results = studentLocations?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let students = StudentLocation.studentsFromResults(results)
                    StudentData.locationArray = students
                    print(students)
                    completionHandlerForStudentLocations(true,nil)
                } else {
                    completionHandlerForStudentLocations(nil,NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
    }
    
    func returnStudents(_ completionHandlerForStudents: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        
        getAllStudentLocations(100) { (success, error) in
            if success! {
                completionHandlerForStudents(true,nil)
            } else {
                completionHandlerForStudents(false,"error at returnStudents")
            }
        }
    

    }
    
}
