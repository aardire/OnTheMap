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
    
    
    private func getStudentLocation(_ numOfStudents: Int, completionHandlerForStudentLocations: @escaping (_ students: [StudentLocation]?, _ error: NSError?) -> Void ) {
        
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
                    completionHandlerForStudentLocations(students,nil)
                } else {
                    completionHandlerForStudentLocations(nil,NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
    }
    
    func createStudentsDictionary(_ completionHandlerForAnnotations: @escaping (_ students: [StudentLocation]?,_ error: NSError?) -> Void) {
        
        getStudentLocation(100) { (studentsDict, error) in
            
            if let error = error {
                print(error)
                completionHandlerForAnnotations(nil, error)
            } else {
                completionHandlerForAnnotations(studentsDict,nil)
            }
        }
    }
    
   
    
    
    
    
    
    
}
