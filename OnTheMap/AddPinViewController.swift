//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/23/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddPinViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var newPinMap: MKMapView!
    @IBOutlet weak var addUrlText: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    var keyboardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        addUrlText.delegate = self
        performUIUpdatesOnMain {
            self.addLocationPin(User.Information.tempCoordinates)
            
        }
    }
    
    
    //MARK: Submit information to Parse and return to sending VC (map or tableview)

    @IBAction func submitButton(_ sender: Any) {
        configUI(false)
        
        User.Information.MediaURL = addUrlText.text!
        
        guard addUrlText?.text!.isEmpty == false else {
            configUI(true)
            showAlert(message: ErrorMessages.urlInputError)
            return
        }
        
        ParseClient.sharedInstance().addNewStudent() {(success) in
            
            guard success else {
                performUIUpdatesOnMain {
                    self.showAlert(message: ErrorMessages.newPinError)
                    self.addUrlText.text = ""
                }
                return
            }
            
            performUIUpdatesOnMain {
                self.configUI(true)
                self.addUrlText.text = ""
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Cancel button tapped
    @IBAction func cancelButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewResizerOnKeyboardShown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(addUrlText)
    }
    
    func configUI(_ input: Bool) {
        addUrlText.isEnabled = input
        submitButton.isEnabled = input
    }
    
    
    // MARK: - MKMapViewDelegate
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
    
    //MARK: Add pin to the map
    func addLocationPin(_ coordinates: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        User.Information.Latitude = coordinates.latitude
        User.Information.Longitude = coordinates.longitude
        annotation.title = "Your location"
        newPinMap.addAnnotation(annotation)
        
        // set region in order to center map
        
        let regionRadius: CLLocationDistance = 10000         // in meters
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates, regionRadius, regionRadius)
        
        newPinMap.setRegion(coordinateRegion, animated: true)
    }
    
}

