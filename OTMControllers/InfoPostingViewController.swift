//
//  InfoPostingView.swift
//  On The Map
//
//  Created by John Nolan on 5/9/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InfoPostingViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var worldImage: UIImageView!
    
    
    @IBAction func submitUserInfo() {
        
        guard locationTextField.text != nil else {
            errorLabel.text = "Please enter a location."
            return
        }
        
        guard urlTextField.text != nil else {
            errorLabel.text = "Please enter a valid URL"
            return
        }
        
        geocodeLocation(address: locationTextField.text!)
        OTMClient.userMediaURL = urlTextField.text!
        
    }
    
    func geocodeLocation (address: String) {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                errorLabel.text = "Geocoding failed. \(error)"
                return
            }
            
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                OTMClient.userLatitude = coordinate?.latitude
                OTMClient.userLongitude = coordinate?.longitude
                
            }
            
            locationTextField.isHidden = true
            urlTextField.isHidden = true
            findLocationButton.isHidden = true
            worldImage.isHidden = true
            errorLabel.text = ""
            mapView.isHidden = false
            finishButton.isHidden = false
        })
    }
}
