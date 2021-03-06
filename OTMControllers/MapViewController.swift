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
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Functions
    override func viewDidLoad() {
        mapView.delegate = self
        OTMClient.sharedInstance().getStudentLocations() {(success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: "Default Action"), style: .default))
                alert.message = error!
                self.present(alert, animated: true, completion: nil)
            }
            
            if success == true {
                for dictionary in OTMClient.studentLocationsInfo {
                    let pin = MKPointAnnotation()
                    let firstName: String
                    let lastName: String
                    let url: String
                    let latitude: Double
                    let longitude: Double
                    
                    //needed due to certain values in Parse API having NSNull which is not accepted by Swift 4
                    if let first = dictionary.firstName {
                        firstName = first
                    } else {
                        firstName = ""
                    }
                    
                    if let last = dictionary.lastName {
                        lastName = last
                    } else {
                        lastName = ""
                    }
                    
                    if let site = dictionary.mediaURL {
                        url = site
                    } else {
                        url = ""
                    }
                    
                    if let lat = dictionary.latitude {
                        latitude = lat
                    } else {
                        latitude = 0.0
                    }
                    
                    if let long = dictionary.longitude {
                        longitude = long
                    } else {
                        longitude = 0.0
                    }
                    
                    //set pin info from parsed info
                    pin.title = "\(firstName) \(lastName)"
                    pin.subtitle = url
                    pin.coordinate.latitude = latitude
                    pin.coordinate.longitude = longitude
                    
                    OTMClient.allPins.append(pin)
                    performUIUpdatesOnMain {
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
    
    //log out by deleting session and clearing the student locations
    @IBAction func logOut (){
        OTMClient.sharedInstance().deleteUdacitySession()
        OTMClient.allPins = []
        dismiss(animated: true, completion: nil)
    }
    
    //delete all previous pins and pull pins from Parse API again
    @IBAction func refreshPins(_ sender: Any) {
        
        OTMClient.sharedInstance().getStudentLocations() {(success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: "Default Action"), style: .default))
                alert.message = error!
                self.present(alert, animated: true, completion: nil)
            }
            
            if success == true {
                OTMClient.allPins = []
                for dictionary in OTMClient.studentLocationsInfo {
                    let pin = MKPointAnnotation()
                    let firstName: String
                    let lastName: String
                    let url: String
                    let latitude: Double
                    let longitude: Double
                    
                    //needed due to some info in Parse API being populated with NSNull type which is not accepted by Swift 4
                    if let first = dictionary.firstName {
                        firstName = first
                    } else {
                        firstName = ""
                    }
                    
                    if let last = dictionary.lastName {
                        lastName = last
                    } else {
                        lastName = ""
                    }
                    
                    if let site = dictionary.mediaURL {
                        url = site
                    } else {
                        url = ""
                    }
                    
                    if let lat = dictionary.latitude {
                        latitude = lat
                    } else {
                        latitude = 0.0
                    }
                    
                    if let long = dictionary.longitude {
                        longitude = long
                    } else {
                        longitude = 0.0
                    }
                    
                    //populate pin info with info from parsed data
                    pin.title = "\(firstName) \(lastName)"
                    pin.subtitle = url
                    pin.coordinate.latitude = latitude
                    pin.coordinate.longitude = longitude
                    
                    //add the pin to the
                    OTMClient.allPins.append(pin)
                    performUIUpdatesOnMain {
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
}

