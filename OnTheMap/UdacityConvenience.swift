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
    private func authUdactiyAccount(_ parameters: [String: String], completionHandlerForUdactiyAccount: @escaping (_ registration: Bool,_ uniqueKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityPOST(parameters) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForUdactiyAccount(false, nil, "Login Failed (return error)")
            } else {
                if let accountInfo = results?["account"] as? [String: AnyObject] {
                    if let registration = accountInfo["registered"] as? Bool {
                        if let uniqueKey = accountInfo["key"] as? String {
                            completionHandlerForUdactiyAccount(registration,uniqueKey,nil)
                        } else {
                            completionHandlerForUdactiyAccount(registration,nil, "unique key error")
                        }
                    } else {
                        completionHandlerForUdactiyAccount(false,nil,"registration error")
                    }
                } else {
                    completionHandlerForUdactiyAccount(false,nil,"accountInfo error")
                }
            }
        }
    }
    
    
    private func getUserData(_ uniqueKey: String, _ completionHandlerForUserData: @escaping (_ sucess: Bool, _ results: [String:AnyObject]?, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityGET(uniqueKey) { (results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForUserData(false,nil,"Unique ID failed")
            } else {
                if let userInfo = results?["user"] as? [String:AnyObject] {
                    completionHandlerForUserData(true,userInfo,nil)
                } else {
                    completionHandlerForUserData(false,nil,"error with UserInfo")
                }
            }
        }
    }
    
    func getUdacityUserInfo(_ parameters: [String: String], completionHandlerForUserInfo: @escaping (_ sucess: Bool, _ errorString: String?) -> Void) {
        
        authUdactiyAccount(parameters) { (registered, uniqueID, error) in
            
            if registered {
                
                self.unique_ID = uniqueID!
                
                self.getUserData(uniqueID!) { (sucess, userInfo, errorString) in
                    
                    if sucess {
                        
                        self.firt_Name = userInfo?["first_name"] as! String
                        self.last_Name = userInfo?["last_name"] as! String
                        
                        completionHandlerForUserInfo(sucess, nil)
                        
                    } else {
                        completionHandlerForUserInfo(sucess,errorString)
                    }
                }
            } else {
                completionHandlerForUserInfo(registered, error)
            }
        }
    }
    
}
