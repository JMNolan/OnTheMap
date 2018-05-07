//
//  ViewController.swift
//  On The Map
//
//  Created by John Nolan on 4/2/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Properties
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        OTMClient.sharedInstance().getStudentLocations() {(success, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if success == true {
                for dictionary in OTMClient.studentLocations {
                    print(dictionary)
                    let pin = MKPointAnnotation()
                    let firstName: String
                    let lastName: String
                    let url: String
                    let latitude: Double
                    let longitude: Double
                    
                    if let first = dictionary[OTMClient.StudentLocationResponseKeys.FirstName] as? String {
                        firstName = first
                    } else {
                        firstName = ""
                    }
                    
                    if let last = dictionary[OTMClient.StudentLocationResponseKeys.LastName] as? String {
                        lastName = last
                    } else {
                        lastName = ""
                    }
                    
                    if let site = dictionary[OTMClient.StudentLocationResponseKeys.MediaURL] as? String {
                        url = site
                    } else {
                        url = ""
                    }
                    
                    if let lat = dictionary[OTMClient.StudentLocationResponseKeys.Latitude] as? Double {
                        latitude = lat
                    } else {
                        latitude = 0.0
                    }
                    
                    if let long = dictionary[OTMClient.StudentLocationResponseKeys.Longitude] as? Double {
                        longitude = long
                    } else {
                        longitude = 0.0
                    }
                    
                    
                    pin.title = "\(firstName) \(lastName)"
                    pin.subtitle = url
                    pin.coordinate.latitude = latitude
                    pin.coordinate.longitude = longitude
                    
                    if OTMClient.allPins.contains(pin) {
                        return
                    } else {
                        OTMClient.allPins.append(pin)
                        performUIUpdatesOnMain {
                            self.mapView.addAnnotation(pin)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addMyLocation(_ sender: Any) {
        
        OTMClient.sharedInstance().getStudentLocation()
    }
    
    
    @IBAction func refreshPins(_ sender: Any) {
        
        OTMClient.sharedInstance().getStudentLocations() {(success, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            if success == true {
                for dictionary in OTMClient.studentLocations {
                    print(dictionary)
                    let pin = MKPointAnnotation()
                    let firstName: String
                    let lastName: String
                    let url: String
                    let latitude: Double
                    let longitude: Double
                    
                    if let first = dictionary[OTMClient.StudentLocationResponseKeys.FirstName] as? String {
                        firstName = first
                    } else {
                        firstName = ""
                    }
                    
                    if let last = dictionary[OTMClient.StudentLocationResponseKeys.LastName] as? String {
                        lastName = last
                    } else {
                        lastName = ""
                    }
                    
                    if let site = dictionary[OTMClient.StudentLocationResponseKeys.MediaURL] as? String {
                        url = site
                    } else {
                        url = ""
                    }
                    
                    if let lat = dictionary[OTMClient.StudentLocationResponseKeys.Latitude] as? Double {
                        latitude = lat
                    } else {
                        latitude = 0.0
                    }
                    
                    if let long = dictionary[OTMClient.StudentLocationResponseKeys.Longitude] as? Double {
                        longitude = long
                    } else {
                        longitude = 0.0
                    }
                    
                    
                    pin.title = "\(firstName) \(lastName)"
                    pin.subtitle = url
                    pin.coordinate.latitude = latitude
                    pin.coordinate.longitude = longitude
                    
                    if OTMClient.allPins.contains(pin) {
                        return
                    } else {
                        OTMClient.allPins.append(pin)
                        performUIUpdatesOnMain {
                            self.mapView.addAnnotation(pin)
                        }
                    }
                }
            }
        }
    }
}

