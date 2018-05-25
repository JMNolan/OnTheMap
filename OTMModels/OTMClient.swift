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
    static var userKey = ""
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
    static var userObjectID: String!
    
    //user input for updating pin
    static var userInputLatitude: Double!
    static var userInputLongitude: Double!
    static var userInputURL: String!
    static var userInputExists: Bool!
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}
