//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/17/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
   
    
    // MARK: Outlets 
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        getCurrentStatus()
    }
    
    // MARK: get current students - make network request and populate for current view. 
    private func getCurrentStatus() {
        
        var annotations = [MKPointAnnotation]()
        
        ParseClient.sharedInstance.returnStudents(100) { (success) in
            
            performUIUpdatesOnMain {
                if success {
                    
                    for student in StudentData.locationArray {
                        
                        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude), longitude: CLLocationDegrees(student.longitude))
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(student.firstName) \(student.lastName)"
                        annotation.subtitle = student.mediaURL
                        
                        annotations.append(annotation)
                    }
                } else {
                    self.showAlert(message: ErrorMessages.dataError)
                }
                self.mapView.addAnnotations(annotations)
            }
        }
        
    }
    
// MARK: Refresh Button 
    
    @IBAction func refreshButton(_ sender: Any) {
        
        getCurrentStatus()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        UdactiyClient.sharedInstance.udactiySessionDELETE() {(success) in
            
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAlert(message: ErrorMessages.logoutError)
                }
            }
        }
    }
    
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                var componets = URLComponents()
                componets.scheme = "HTTPS"
                componets.host = toOpen
                app.open(componets.url!)
            }
        }
    }
    
}
