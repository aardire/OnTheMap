//
//  UdactiyClient.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/10/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import Foundation

// MARK: UdactiyClient: NSObject 

class UdactiyClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    
    // MARK: Convenience Functions
    
    func getRegistration(_ parameters: [String:AnyObject], completionHandlerForUserID: @escaping (_ success: Bool, _ userID: String?, _ errorString: String?) -> Void) {
        
        
        let _ = taskForUdacityPOST(parameters) { (results, error) in
            
            guard let accountInfo = results?["account"] as? [String:AnyObject] else {
                completionHandlerForUserID(false,nil,"Error Retrieving Account Information")
                return
            }
            
            guard let registration = accountInfo["registered"] as? Bool else {
                completionHandlerForUserID(false,nil,"Error Retrieving Account Information")
                return
            }
            
            guard let userKey = accountInfo["key"] as? String else {
                completionHandlerForUserID(false,nil,"Error Retrieving Account Information")
                return
            }
            
            
            completionHandlerForUserID(registration,userKey,nil)
            

        }
        
        
    }
    
    // MARK: networking functions
    
    func taskForUdacityPOST(_ parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask  {
        
       /* 1. Set the parameters */
        let userName = parameters["username"] as? String
        let userPassword = parameters["password"] as? String
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(userPassword)\"}}".data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
          
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            /* 5/6. Parse the data and use the data */
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            completionHandlerForPOST(parsedResult,nil)

        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
        // MARK: Shared Instance
    
    class func sharedInstance() -> UdactiyClient {
        struct Singleton {
            static var sharedInstance = UdactiyClient()
        }
        return Singleton.sharedInstance
    }

    
}
