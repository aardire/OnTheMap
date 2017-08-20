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
    
    
    private func getStudentLocation(_ numOfStudents: Int,_ skip: Int, completionHandlerForStudentLocations: @escaping (_ students: [StudentLocation]?, _ error: NSError?) -> Void ) {
        
        /* Specify Parameters for taskforGet */
        var parameters = [String: AnyObject]()
        parameters[ParseClient.Parameters.Limit] = numOfStudents as AnyObject
        parameters[ParseClient.Parameters.Skip] = skip as AnyObject
        
        let _ = taskForGetMethod(parameters) { (studentLocations, error) in
            
            if let error = error {
                print(error)
                completionHandlerForStudentLocations(nil,error)
            } else {
                if let results = studentLocations?[ParseClient.ResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let students = StudentLocation.studentsFromResults(results)
                    print(students)
                    completionHandlerForStudentLocations(students,nil)
                } else {
                    completionHandlerForStudentLocations(nil,NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
    }
    
    func createStudentsDictionary(_ completionHandlerForAnnotations: @escaping (_ students: [StudentLocation]?,_ error: NSError?) -> Void) {
        
        getStudentLocation(100,200) { (studentsDict, error) in
            
            if let error = error {
                print(error)
                completionHandlerForAnnotations(nil, error)
            } else {
                completionHandlerForAnnotations(studentsDict,nil)
            }
        }
    }
    
   
    
    
    
    
    
    
}
