//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/10/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    // MARK: Properties
    lazy var geocoder = CLGeocoder()
    let activity = UIActivityIndicatorView()
    let user = UdactiyClient.sharedInstance()
    
    // MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var geocodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func geocode(_ sender: Any) {
        
        if let locationString = textView.text {
            user.mapString = locationString
            geocoder.geocodeAddressString(locationString) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        } else {
            // alert
            return
        }
        
        geocodeButton.isHidden = true
        activity.startAnimating()
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
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
                
            } else {
                
            }
        }
    }
}

