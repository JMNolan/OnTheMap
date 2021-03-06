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
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100?order=-updatedAt")!)
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
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "Request failed. Status code \(statusCode!). Please try again later.")
                return
            }

            do {
                let studentData = try JSONDecoder().decode(OTMClient.getStudentLocationsStruct.self, from: data)
                OTMClient.studentLocationsInfo = studentData.results
            } catch {
                completionHandler(false, "Data parse failed:\(error)")
                return
            }
            OTMClient.locationsPulledSuccessfully = true
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    //post user name, location, and url to Parse
    func postStudentLocation (_ name: String, _ url: String, _ latitude: Double, _ longitude: Double, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OTMClient.userKey)\", \"firstName\": \"\(OTMClient.userFirstName!)\", \"lastName\": \"\(OTMClient.userLastName!)\",\"mapString\": \"\(OTMClient.userMapString!)\", \"mediaURL\": \"\(OTMClient.userMediaURL!)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, "An error occured while attempting to post information to Parse servers")
                return
            }
            
            guard let data = data else {
                completionHandler(false, "Unable to obtain data with postUdacitySession request")
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "An error ocurred with your request. Error:\(statusCode!)")
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                completionHandler(false, "Unable to parse data from request")
                return
            }
            
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    //update student location information from previously inputted information
    func putStudentLocation (_ url: String, _ latitude: Double, _ longitude: Double, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(OTMClient.userObjectID!)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(OTMClient.userKey)\", \"firstName\": \"\(OTMClient.userFirstName!)\", \"lastName\": \"\(OTMClient.userLastName!)\",\"mapString\": \"\(OTMClient.userMapString!)\", \"mediaURL\": \"\(OTMClient.userMediaURL!)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false, "An error occured while requesting information from Udacity")
                return
            }
            
            guard let data = data else {
                completionHandler(false, "Unable to obtain data with putUdacitySession reqeust")
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "Failed request. Status code:\(statusCode!)")
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                completionHandler(false, "Unable to parse data from PUT request")
                return
            }
            
            completionHandler(true, nil)
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
                completionHandler(false, "An error occured while requesting information from Udacity")
                return
            }
            
            guard let data = data else {
                completionHandler(false, "Unable to obtain data with postUdacitySession reqeust")
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false, "Request failed. Status code:\(statusCode!)")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(false, "Error parsing data: \(error)")
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
    
    //get a singular student's info from Parse
    func getStudentLocation(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        guard OTMClient.userKey != "" else {
            completionHandler(false)
            return
        }
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(OTMClient.userKey)%22%7D"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.ApplicationIDHeader)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.RestAPIHeader)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error retrieving data (getSudentLocation)")
                completionHandler(false)
                return
            }
            guard let data = data else {
                completionHandler(false)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! <= 299 && statusCode! >= 200 else {
                completionHandler(false)
                print(statusCode!)
                return
            }
            
            var parsedData: [String:AnyObject]!
            
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Error parsing data: \(error)")
                completionHandler(false)
            }
            
            guard let parsedResults = parsedData[OTMClient.StudentLocationResponseKeys.Results] as! [[String:AnyObject]]? else {
                print("No Student Info Found")
                completionHandler(false)
                return
            }
            for dictionary in parsedResults {
            OTMClient.userObjectID = (dictionary[OTMClient.StudentLocationResponseKeys.ObjectID])! as! String
            OTMClient.userFirstName = (dictionary[OTMClient.StudentLocationResponseKeys.FirstName])! as! String
            OTMClient.userLastName = dictionary[OTMClient.StudentLocationResponseKeys.LastName] as! String
            }
            completionHandler(true)
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
            if error != nil {
                print(error!)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            do {
                try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
            } catch {
                print("Failed to parse results from delete session request")
                return
            }
        }
        task.resume()
    }
    
    //pulls public user data from Udacity database
    func getUserData () {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(OTMClient.userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Request for getUserData failed: \(String(describing: error))")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            var parsedData: [String:AnyObject]
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Error parsing data: \(error)")
                return
            }
            
            let userData = parsedData["user"] as! [String:AnyObject]
            if let firstName = userData["first_name"] as? String {
                OTMClient.userFirstName = firstName
            }
            OTMClient.userLastName = (userData["last_name"])! as! String
        }
        task.resume()
    }
}
