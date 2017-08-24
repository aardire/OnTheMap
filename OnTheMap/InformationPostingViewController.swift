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

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    

    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(locationInput, self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewResizerOnKeyboardShown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
 
    //MARK: Find button tapped
    @IBAction func findButton(_ sender: Any) {
        
        //start
        activityIndicator.startAnimating()
        
        guard locationInput.text!.isEmpty == false else {
            //stop
            activityIndicator.stopAnimating()
            self.showAlert(message: ErrorMessages.inputError)
            return
        }
        
        performUIUpdatesOnMain {
            self.geocodeAddress(self.locationInput.text!)
        }
    }
    
    //MARK: Cancel button tapped
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    //MARK: Function to geocode address String
    private func geocodeAddress(_ inputLocation: String) {
        self.geocoder.geocodeAddressString(inputLocation) { (placemarks, error) in
            
            if error != nil {
                //stop
                self.activityIndicator.stopAnimating()
                self.showAlert(message: ErrorMessages.geoError)
                self.locationInput.text = ""
                
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    User.Information.tempCoordinates = location.coordinate
                } else {
                    //stop
                    self.activityIndicator.stopAnimating()
                    self.showAlert(message: ErrorMessages.locError)
                }
                
                performUIUpdatesOnMain {
                    //stop
                    self.activityIndicator.stopAnimating()
                    
                    User.Information.MapString = inputLocation
                    self.performSegue(withIdentifier: "AddPin", sender: self)
                }
            }
        }
    }
  
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(locationInput)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func keyboardWillShow(_ notification: Notification) {
       
        inputLabel.isHidden = true
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        
        inputLabel.isHidden = false
    }
}
