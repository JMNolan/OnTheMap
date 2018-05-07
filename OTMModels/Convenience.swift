//
//  Convenience.swift
//  On The Map
//
//  Created by John Nolan on 4/3/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    
    func getStudentLocations (completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void ) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        request.addValue(OTMClient.Constants.ApplicationID, forHTTPHeaderField: OTMClient.Constants.ApplicationIDHeader)
        request.addValue(OTMClient.Constants.ApiKey, forHTTPHeaderField: OTMClient.Constants.RestAPIHeader)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, "An error occured with the URL request")
                return
            }
            
            guard let data = data else {
                completionHandler(false, "Unable to locate data in request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode <= 299 && statusCode >= 200 else {
                completionHandler(false, "Status code returned is not 2XX")
                return
            }
            
            var parsedData: [String:AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(false, "Unable to parse data")
            }
            
            guard let results = parsedData[OTMClient.StudentLocationResponseKeys.Results] as! [[String:AnyObject]]? else {
                completionHandler(false, "Unable to find entry 'results' in \(parsedData)")
                return
            }
            
            OTMClient.studentLocations = results
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func postUdacitySession (_ username: String, _ password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error retrieving data (postUdacitySession)")
                completionHandler(false, "An error occured while requesting information from Udacity")
                return
            }
            
            guard let data = data else {
                print("Request to post session was unsuccessfull")
                completionHandler(false, "Unable to obtain data with postUdacitySession reqeust")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode <= 299 && statusCode >= 200 else {
                print("Status code is not 2xx")
                completionHandler(false, "Invalid Status Code")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Error parsing data: \(newData)")
            }
            
            guard let session = parsedResult[OTMClient.UdacitySessionResponseKeys.Session] else {
                completionHandler(false, "Unable to find 'session' in \(parsedResult)")
                return
            }
            
            guard let sessionID = session[OTMClient.UdacitySessionResponseKeys.ID] as! String? else {
                completionHandler(false, "Unable to find entry: \(OTMClient.UdacitySessionResponseKeys.Session)")
                return
            }
            
            guard let account = parsedResult[OTMClient.UdacitySessionResponseKeys.Account] else {
                completionHandler(false, "Unable to find entry 'account' in \(parsedResult)")
                return
            }
            
            guard let key = account[OTMClient.UdacitySessionResponseKeys.Key] as! String? else {
                completionHandler(false, "Unable to find entry: \(OTMClient.UdacitySessionResponseKeys.Key)")
                return
            }
            
            OTMClient.sessionID = sessionID
            OTMClient.userKey = key
            completionHandler(true,nil)
        }
        task.resume()
    }
    
    func getStudentLocation (completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void ) {
        
        guard Methods.UniqueKeyString != "" else {
            print("UniqueKey required for user")
            return
        }
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation\(Methods.UniqueKeyString)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error retrieving data (getSudentLocation)")
                completionHandler(false, "An Error Occurred")
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
//    func postStudentLocation () {
//        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "PUT"
//        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
//        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil {
//                print("Error retrievig data (postStudentLocation)")
//                return
//            }
//            print(String(data: data!, encoding: .utf8)!)
//        }
//        task.resume()
//    }
    
    func deleteUdacitySession () {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getUserData () {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
