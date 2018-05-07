//
//  studentLocationInfo.swift
//  On The Map
//
//  Created by John Nolan on 4/12/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import MapKit

class studentLocationInfo: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title as? String ?? nil
        self.subtitle = subtitle as? String ?? nil
        self.coordinate = (coordinate as? CLLocationCoordinate2D ?? nil)!
        
        super.init()
    }
}
