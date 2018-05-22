//
//  Convenience.swift
//  On The Map
//
//  Created by John Nolan on 4/3/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension OTMClient {
    
    //retrieve student locations from Udaicty Parse API
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
    
    //post user name, location, and url to Parse
    func postStudentLocation (_ name: String, _ url: String, _ latitude: Double, _ longitude: Double) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OTMClient.userKey)\", \"firstName\": \"\(OTMClient.userFirstName!)\", \"lastName\": \"\(OTMClient.userLastName!)\",\"mapString\": \"\(OTMClient.userMapString!)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error retrievig data (postStudentLocation)")
                return
            }
        }
        task.resume()
    }
    
    //update student location information from previously inputted information
    func putStudentLocation (_ url: String, _ latitude: Double, _ longitude: Double) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(OTMClient.userObjectID)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OTMClient.userKey)\", \"firstName\": \"\(OTMClient.userFirstName)\", \"lastName\": \"\(OTMClient.userLastName)\",\"mapString\": \"\(OTMClient.userMapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Request to putStudentLocation failed")
                return
            }
        }
        task.resume()
    }
    
    //post a session as a means of obtaining user unique key and authenticating user
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
            print(OTMClient.userKey)
            completionHandler(true,nil)
        }
        task.resume()
    }
    
    //get a singular student's info from Parse
    func getStudentLocation() {
        
        guard OTMClient.userKey != "" else {
            print("UniqueKey required for user")
            return
        }
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(OTMClient.userKey)%22%7D"
        print(urlString)
        let url = URL(string: urlString)
        print(url!)
        var request = URLRequest(url: url!)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error retrieving data (getSudentLocation)")
                return
            }
            guard let data = data else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode <= 299 && statusCode >= 200 else {
                return
            }
            var parsedData: [String:AnyObject]!
            
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Error parsing data")
            }
            
            print(parsedData)
            guard let parsedResults = parsedData[OTMClient.StudentLocationResponseKeys.Results] as! [[String:AnyObject]]? else {
                print("No Student Info Found")
                return
            }
            print(parsedResults)
            for dictionary in parsedResults {
            OTMClient.userObjectID = (dictionary[OTMClient.StudentLocationResponseKeys.ObjectID])! as! String
            OTMClient.userFirstName = (dictionary[OTMClient.StudentLocationResponseKeys.FirstName])! as! String
            OTMClient.userLastName = dictionary[OTMClient.StudentLocationResponseKeys.LastName] as! String
            }
        }
        task.resume()
    }
    
    //used for loggin out of session
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
        }
        task.resume()
    }
    
    //pulls public user data from Udacity database
    func getUserData () {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(OTMClient.userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Request for getUserData failed")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            var parsedData: [String:AnyObject]
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Error parsing data")
                return
            }
            
            let userData = parsedData["user"] as! [String:AnyObject]
            if let firstName = userData["first_name"] as? String {
                OTMClient.userFirstName = firstName
            }
            OTMClient.userLastName = (userData["last_name"])! as! String

            print("\(OTMClient.userFirstName!) \(OTMClient.userLastName!)")
        }
        task.resume()
    }
}
