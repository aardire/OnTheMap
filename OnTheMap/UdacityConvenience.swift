//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

extension UdactiyClient {
    
    // MARK: get registration and unique ID
    private func authUdactiyAccount(_ userName: String?,_ userPassword: String?, completionHandlerForUdactiyAccount: @escaping (_ registration: Bool,_ uniqueKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForUdacityPOST(userName!,userPassword!) { (results, error) in
            
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
        
        taskForUdacityGET(uniqueKey) { (results, error) in
            
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
    
    func getUdacityUserInfo(_ userName: String?,_ userPassword: String?, completionHandlerForUserInfo: @escaping (_ sucess: Bool, _ errorString: String?) -> Void) {
        
        authUdactiyAccount(userName!,userPassword!) { (registered, uniqueID, error) in
            
            if registered {
                
                User.Information.UniqueKey = uniqueID!
                
                self.getUserData(uniqueID!) { (sucess, userInfo, errorString) in
                    
                    if sucess {
                        
                        User.Information.FirstName = userInfo?["first_name"] as! String
                        User.Information.LastName = userInfo?["last_name"] as! String
                        
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
