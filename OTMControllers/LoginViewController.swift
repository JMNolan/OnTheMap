//
//  LoginViewController.swift
//  On The Map
//
//  Created by John Nolan on 4/4/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var alertMessage: String!
    // MARK: Functions
    
    //take user to sign up url for udacity
    @IBAction func signUpButtonPressed () {
        
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    //take user input and send a post request to Udacity to validate user credentials
    @IBAction func loginButtonPressed () {
        
        let alert = UIAlertController(title: "Login Failed", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: "Default Action"), style: .default))
        
        guard usernameTextField.text != "" else {
            alertMessage = "Please enter a valid username"
            alert.message = alertMessage
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard passwordTextField.text != "" else {
            alertMessage = "Please enter a valid password"
            alert.message = alertMessage
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        OTMClient.sharedInstance().postUdacitySession (usernameTextField.text!, passwordTextField.text!) {(success, error) in
            if error != nil {
                if error == "403" {
                    self.alertMessage = "Your username or password are incorrect. Please try again."
                } else {
                    self.alertMessage = "Your connection failed. Please check your connection and try again."
                }
                DispatchQueue.main.async(execute: {
                    alert.message = self.alertMessage
                    self.present(alert, animated: true, completion: nil)})
               
            } else if success {
                performUIUpdatesOnMain {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
        
        }
    }
}
