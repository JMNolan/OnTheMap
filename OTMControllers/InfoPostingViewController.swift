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

class InfoPostingViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var worldImage: UIImageView!
    @IBOutlet weak var geocodeActivityIndicator: UIActivityIndicatorView!
    
    
    let pin = MKPointAnnotation()
    let alert = UIAlertController(title: "Submission Failed", message: "", preferredStyle: .alert)
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return true
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        
        self.geocodeActivityIndicator.isHidden = true
        self.urlTextField.delegate = self
        self.locationTextField.delegate = self
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style:.default))
        OTMClient.sharedInstance().getStudentLocation(completionHandler: { (success) in
            if success {
                if OTMClient.userFirstName == nil || OTMClient.userLastName == nil{
                    OTMClient.sharedInstance().getUserData()
                    OTMClient.userInputExists = false
                } else {
                    OTMClient.userInputExists = true
                }
            }
        })
    }
    
    //returns the user to the mapView from the search view or from the confirm view to search view depending on the title of the cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if cancelButton.title == "Cancel" {
            self.dismiss(animated: true, completion: nil)
        } else {
            performUIUpdatesOnMain {
                self.locationTextField.isHidden = false
                self.urlTextField.isHidden = false
                self.findLocationButton.isHidden = false
                self.worldImage.isHidden = false
                self.mapView.isHidden = true
                self.finishButton.isHidden = true
                self.cancelButton.title = "Cancel"
            }
        }
    }
    
    //convert user input to a usable location and store inputted url
    @IBAction func searchUserInfo() {
        
        guard OTMClient.locationsPulledSuccessfully == true else {
            alert.message = "Student locations were not pulled successfully. Please return to the map and refresh to try again."
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard locationTextField.text != nil && locationTextField.text != "" else {
            alert.message = "Please enter a valid location"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard urlTextField.text != nil && urlTextField.text != "" else {
            alert.message = "Please enter a valid url"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        geocodeLocation(address: locationTextField.text!)
        OTMClient.userMediaURL = urlTextField.text!
        OTMClient.userMapString = locationTextField.text!
        self.view.endEditing(true)
        
    }
    
    //user posts inputted information to udacity parse
    @IBAction func submitUserInfo() {

        if !OTMClient.userInputExists {
            OTMClient.sharedInstance().postStudentLocation("\(OTMClient.userFirstName!) \(OTMClient.userLastName!)", OTMClient.userMediaURL!, OTMClient.userLatitude!, OTMClient.userLongitude!, completionHandler: { (success, error) in
                if error != nil {
                    self.alert.message = "\(error!)"
                    self.present(self.alert, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            OTMClient.sharedInstance().putStudentLocation(OTMClient.userMediaURL, OTMClient.userLatitude, OTMClient.userLongitude, completionHandler: { (success, error) in
                if error != nil {
                    self.alert.message = "\(error!)"
                    self.present(self.alert, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
    }
    
    //change user inputted location to a usable location
    func geocodeLocation (address: String) {
        
        self.geocodeActivityIndicator.isHidden = false
        self.geocodeActivityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                self.alert.message = "Geocoding failed"
                self.present(self.alert, animated: true, completion: nil)
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
                self.mapView.isHidden = false
                self.finishButton.isHidden = false
                self.cancelButton.title = "Add Location"
                self.mapView.addAnnotation(self.pin)
            }
            self.geocodeActivityIndicator.stopAnimating()
            self.geocodeActivityIndicator.isHidden = true
        })
    }
}
