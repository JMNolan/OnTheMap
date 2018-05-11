//
//  Client.swift
//  On The Map
//
//  Created by John Nolan on 4/3/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import MapKit

class OTMClient: NSObject {
    
    // MARK: Properties
    static var userKey: String!
    static var sessionID: String!
    static var studentLocations: [[String:AnyObject]]!
    static var allPins: [MKPointAnnotation] = []
    
    //user info
    static var userFirstName: String!
    static var userLastName: String!
    static var userMapString: String!
    static var userMediaURL: String!
    static var userLatitude: Double!
    static var userLongitude: Double!
    
    //user input for updating pin
    static var userInputLatitude: Double!
    static var userInputLongitude: Double!
    static var userInputURL: String!
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
//    func postUdacitySession (_ username: String, _ password: String, completionHandler: @escaping (_ success: Bool, _ errorString: String) -> Void) {
//        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error retrieving data (postUdacitySession)")
//                completionHandler(false, "An error occured while requesting information from Udacity")
//                return
//            }
//            
//            guard let data = data else {
//                print("Request to post session was unsuccessfull")
//                completionHandler(false, "Unable to obtain data with postUdacitySession reqeust")
//                return
//            }
//            let range = Range(5..<data.count)
//            let newData = data.subdata(in: range)
//            
//            do {
//                let parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
//                self.userKey = parsedResult[UdacitySessionResponseKeys.Key] as! String
//                self.sessionID = parsedResult[UdacitySessionResponseKeys.Session] as! String
//                completionHandler(true, "")
//            } catch {
//                print("Error parsing data: \(newData)")
//                completionHandler(false, "Error Parsing data")
//            }
//        }
//        task.resume()
//    }
//    func URLFromParameters (_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
//
//        var components = URLComponents()
//        components.scheme = Constants.ApiScheme
//        components.host = Constants.ApiHost
//        components.path = Constants.ApiPath + (withPathExtension ?? "")
//        components.queryItems = [URLQueryItem]()
//
//        for (key, value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems?.append(queryItem)
//        }
//        return components.url!
//    }
}
