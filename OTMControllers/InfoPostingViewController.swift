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
    
    let pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        OTMClient.sharedInstance().getStudentLocation()
        print("location pulled")
        if OTMClient.userFirstName == nil || OTMClient.userLastName == nil{
            OTMClient.sharedInstance().getUserData()
            print("data gotten")
            OTMClient.userInputExists = false
        } else {
            OTMClient.userInputExists = true
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if cancelButton.title == "Cancel" {
            self.dismiss(animated: true, completion: nil)
        } else {
            performUIUpdatesOnMain {
                self.locationTextField.isHidden = false
                self.urlTextField.isHidden = false
                self.findLocationButton.isHidden = false
                self.worldImage.isHidden = false
                self.errorLabel.text = ""
                self.mapView.isHidden = true
                self.finishButton.isHidden = true
                self.cancelButton.title = "Cancel"
            }
        }
    }
    
    @IBAction func searchUserInfo() {
        
        guard locationTextField.text != nil && locationTextField.text != "" else {
            errorLabel.text = "Please enter a location."
            return
        }
        
        guard urlTextField.text != nil && urlTextField.text != "" else {
            errorLabel.text = "Please enter a valid URL"
            return
        }
        
        geocodeLocation(address: locationTextField.text!)
        OTMClient.userMediaURL = urlTextField.text!
    }
    
    @IBAction func submitUserInfo() {
        if !OTMClient.userInputExists {
            OTMClient.sharedInstance().postStudentLocation("\(OTMClient.userFirstName!) \(OTMClient.userLastName!)", OTMClient.userMediaURL!, OTMClient.userLatitude!, OTMClient.userLongitude!)
            
        } else {
            OTMClient.sharedInstance().putStudentLocation(OTMClient.userMediaURL, OTMClient.userLatitude, OTMClient.userLongitude)
            
        }
    }
    
    func geocodeLocation (address: String) {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                self.errorLabel.text = "Geocoding failed"
                return
            }
            
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                OTMClient.userLatitude = coordinate?.latitude
                OTMClient.userLongitude = coordinate?.longitude
                
                self.pin.title = "\(OTMClient.userFirstName!) \(OTMClient.userLastName!)"
                self.pin.subtitle = OTMClient.userMediaURL!
                self.pin.coordinate.latitude = OTMClient.userLatitude!
                self.pin.coordinate.longitude = OTMClient.userLongitude!
                
            }
            
            performUIUpdatesOnMain {
                self.locationTextField.isHidden = true
                self.urlTextField.isHidden = true
                self.findLocationButton.isHidden = true
                self.worldImage.isHidden = true
                self.errorLabel.text = ""
                self.mapView.isHidden = false
                self.finishButton.isHidden = false
                self.cancelButton.title = "Add Location"
                self.mapView.addAnnotation(self.pin)
            }
        })
    }
}
