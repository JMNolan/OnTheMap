//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by John Nolan on 4/11/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewController: UITableViewController {
    
    // MARK: Properties
    
    
    // MARK: Outlets
    
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        
    }
    
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = OTMClient.allPins.count
        return count
    }
    
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationTableViewCell")
        let pins = OTMClient.allPins[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = pins.title
        return cell!
    }
    
    override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let url = NSURL(string: OTMClient.allPins[(indexPath as NSIndexPath).row].subtitle!)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
}
