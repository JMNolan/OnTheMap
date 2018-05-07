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
    
    
    // MARK: Functions
    
    @IBAction func hereButtonPressed () {
        
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginButtonPressed () {
        
        guard usernameTextField.text != nil else {
            print("User failed to enter a username")
            return
        }
        
        guard passwordTextField.text != nil else {
            print("User failed to enter a password")
            return
        }
        
        OTMClient.sharedInstance().postUdacitySession (usernameTextField.text!, passwordTextField.text!) {(success, error) in
            if error != nil {
                self.loginStatusLabel.text = "Login failed"
                print(error)
            } else if success {
                //self.loginStatusLabel.text = "Login Successful"
                print("HUZAAAAAAH")
                performUIUpdatesOnMain {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
        
        }
    }
}
