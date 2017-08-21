//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/10/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate  {
    
    // MARK: Properties
    lazy var geocoder = CLGeocoder()
    let activity = UIActivityIndicatorView()
    let user = UdactiyClient.sharedInstance()
    
    // MARK: Outlets
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var geocodeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.isHidden = true
    }

    
    @IBAction func geocode(_ sender: Any) {
        
        if let locationString = textView.text {
            user.mapString = locationString
            geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error) {
                    
                    performUIUpdatesOnMain {
                        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.user.latitude), longitude: CLLocationDegrees(self.user.longitude))
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(self.user.firstName) \(self.user.lastName)"
                        
                    }
            }
        }
            // alert
            return
        } else {
            
        }
        
        
        geocodeButton.isHidden = true
        activity.startAnimating()
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?,_ updates: completionHandlerForLocation: @escaping
        () -> Void) {
        // Update View
        geocodeButton.isHidden = false
        activity.stopAnimating()
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                user.latitude = location.coordinate.latitude
                user.longitude = location.coordinate.longitude
                completionHandlerForLocation {
                    self.mapView.isHidden = false
                }
                
            } else {
                
            }
        }
        
        
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    
    func setUIEnabled(_ enabled: Bool) {
        
        textView.isEnabled = enabled
        geocodeButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            geocodeButton.alpha = 1.0
        } else {
            geocodeButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            // debugTextLabel.text = errorString
        }
    }
    
    func configureUI() {
        
        /*
         // configure background gradient
         let backgroundGradient = CAGradientLayer()
         backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
         backgroundGradient.locations = [0.0, 1.0]
         backgroundGradient.frame = view.frame
         view.layer.insertSublayer(backgroundGradient, at: 0)
         */
        
        configureTextField(textView)
       
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        //textField.backgroundColor = Constants.UI.GreyColor
        //textField.textColor = Constants.UI.BlueColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        //textField.tintColor = Constants.UI.BlueColor
        textField.delegate = self
    }
}

// MARK: - LoginViewController (Notifications)

private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
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

}
