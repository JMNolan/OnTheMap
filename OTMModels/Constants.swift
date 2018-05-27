//
//  Constants.swift
//  On The Map
//
//  Created by John Nolan on 4/2/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

extension OTMClient {
    // MARK: Constants
    struct Constants {
        
        // MARK: Rest API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: Application ID
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: Parse URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let ApplicationIDHeader = "X-Parse-Application-Id"
        static let RestAPIHeader = "X-Parse-REST-API-Key"
       
    }
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "/StudentLocation"
        static let UniqueKeyString = "?where=%7B%22uniqueKey%22%3A%22\(OTMClient.sessionID)%22%7D"
        
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
    
    // MARK: StudentLocation Response Keys
    struct StudentLocationResponseKeys {
        static let Results = "results"
        static let CreatedDate = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
    }
    
    // MARK: UdacitySessionResponseKeys
    struct UdacitySessionResponseKeys {
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        static let Account = "account"
    }
    
    // MARK: Student Info Struct
    struct studentInfo {
        let createdAt: String
        let firstName: String
        let lastName: String
        let latitude: Double
        let longitude: Double
        let mapString: String
        let mediaURL: String
        let objectId: String
        let uniqueKey: String
        let updatedAt: String
        
        init?(dictionary: [String:Any]) {
            self.createdAt = dictionary["createdAt"] as? String ?? ""
            self.firstName = dictionary["firstName"] as? String ?? ""
            self.lastName = dictionary["lastName"] as? String ?? ""
            self.latitude = dictionary["latitude"] as? Double ?? 0
            self.longitude = dictionary["longitude"] as? Double ?? 0
            self.mapString = dictionary["mapString"] as? String ?? ""
            self.mediaURL = dictionary["mediaURL"] as? String ?? ""
            self.objectId = dictionary["objectId"] as? String ?? ""
            self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
            self.updatedAt = dictionary["updatedAt"] as? String ?? ""
        }
    }
}

