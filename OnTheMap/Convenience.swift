//
//  Concenience.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/22/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: -  Error alert setup
    func showAlert(message: String) {
        let errMessage = message
        
        let alert = UIAlertController(title: nil, message: errMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Show/Hide Keyboard functions
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    // MARK:keyboardWillShow
    func keyboardWillShow(_ notification:Notification) {
        
    }
    
    // MARK:keyboardWillHide
    
    func keyboardWillHide(_ notification:Notification) {
        
    }
    
    // MARK: getKeyboardHeight
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    struct ErrorMessages {
        static let noInputError = "Please provide login details!"
        static let loginError = "Udacity Login failed. Incorrect username or password."
        static let dataError = "No data was returned."
        static let networkError = "No connection to the Internet!"
        static let userError = "Unable to get user data."
        static let studentError = "Unable to get student data."
        static let genError = "An error was returned."
        static let inputError = "Please insert a location!"
        static let locError = "No matching location found."
        static let newPinError = "Could not add pin."
        static let urlError = "URL cannot be accessed. Please try again or select another student."
        static let refreshError = "Could not refresh locations."
        static let logoutError = "Could not log user out!"
        static let urlInputError = "Please insert a valid URL."
        static let geoError = "Unable to process location. Please enter a valid location."
    }
    
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func configureTextField(_ textField: UITextField,_ VC: UITextFieldDelegate) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.delegate = VC
    }
    
    
}
