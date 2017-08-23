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
    
    struct ErrorMessages {
        static let noInputError = "Please provide login details!"
        static let loginError = "Udacity Login failed. Incorrect username or password."
        static let dataError = "No data was returned."
        static let networkError = "No connection to the Internet!"
        static let userError = "Unable to get user data."
        static let studentError = "Unable to get student data."
        static let genError = "An error was returned."
        static let inputError = "Please insert a location!"
        static let locError = "No matching location found."
        static let newPinError = "Could not add pin."
        static let urlError = "URL cannot be accessed. Please try again or select another student."
        static let refreshError = "Could not refresh locations."
        static let logoutError = "Could not log user out!"
        static let urlInputError = "Please insert a valid URL."
        static let geoError = "Unable to process location. Please enter a valid location."
    }
    /*
    let dictionary: [String:AnyObject] = [
        "uniqueKey": Uaccount,
        "firstName": firstName,
        "lastName": lastName,
        "mapString": mapString,
        "mediaURL": mediaURL,
        "latitude": latitude,
        "longitude": longitude
    ]
 */
    
}
