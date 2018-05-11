//
//  MapViewDelegate.swift
//  On The Map
//
//  Created by John Nolan on 4/12/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "pin"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    //action if user taps annotation pop up
    func mapView(_ mapview: MKMapView, annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl) {
        
        let url = URL(string: ((view.annotation?.subtitle)!)!)
        print(url!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}
