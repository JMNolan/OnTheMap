//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by John Nolan on 4/11/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationTableViewController: UITableViewController {
    
    // MARK: Functions
    override func viewDidLoad() {
        
    }
    
    //set number of rows
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = OTMClient.allPins.count
        return count
    }
    
    //set row content
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationTableViewCell")
        let pins = OTMClient.allPins[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = pins.title
        return cell!
    }
    
    //set action when row tapped
    override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = NSURL(string: OTMClient.allPins[(indexPath as NSIndexPath).row].subtitle!)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func logOut (){
        OTMClient.sharedInstance().deleteUdacitySession()
        OTMClient.allPins = []
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshPins(_ sender: Any) {
        
        OTMClient.sharedInstance().getStudentLocations() {(success, error) in
            guard error == nil else {
                print(error!)
                return
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
                }
            }
        }
    }
}
