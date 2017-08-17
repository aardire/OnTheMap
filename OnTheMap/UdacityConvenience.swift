//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

extension UdactiyClient {
    
    // MARK: authenticate Udacity User
    
    
    // MARK: get registration and unique ID 
    func getUdactiyAccount(_ parameters: [String: String], completionHandlerForUdactiyAccount: @escaping (_ registration: Bool?,_ uniqueKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityPOST(parameters) { (results, error) in
            
            guard let accountInfo = results?["account"] as? [String:Any] else {
                completionHandlerForUdactiyAccount(nil,nil,"Error Retrieving Account Information")
                return
            }
            
            guard let registration = accountInfo["registered"] as? Bool else {
                completionHandlerForUdactiyAccount(nil,nil, "Error Retrieving Registration Information")
                return
            }
            
            guard let uniqueKey = accountInfo["key"] as? String else {
                completionHandlerForUdactiyAccount(nil,nil,"Error Retrieving UniqueKey")
                return
            }
            
            completionHandlerForUdactiyAccount(registration,uniqueKey,nil)
        }
    }
    
    func getUserData(_ uniqueKey: String, _ completionHandlerForUserData) {
        
        let _ = taskForUdacityGET(uniqueKey) { (results, error) in
            
            guard let userInfo = results?["user"] as? [String:Any] else {
                
            }
        }
    }
    
    
    
}
