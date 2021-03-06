//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/10/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var userName:String?
    var userPassword: String?
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupViewResizerOnKeyboardShown()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        startNetworkActivity()
        
        userName = usernameTextField.text!
        userPassword = passwordTextField.text!
        
        guard self.userName?.isEmpty == false && self.userPassword?.isEmpty == false else {
            stopNetworkActivity()
            self.showAlert(message: ErrorMessages.noInputError)
            return
        }
        
        Connectivity.isInternetAvailable(webSiteToPing: nil) { (success) in
            guard success else {
                self.stopNetworkActivity()
                self.passwordTextField.text = ""
                self.showAlert(message: ErrorMessages.networkError)
                return
            }
        }
            
        UdactiyClient.sharedInstance.getUdacityUserInfo(self.userName!,self.userPassword!) { (sucess, error) in
            
            guard sucess else {
                performUIUpdatesOnMain {
                    self.stopNetworkActivity()
                    self.showAlert(message: ErrorMessages.loginError)
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
                return
            }
            
            performUIUpdatesOnMain {
                self.stopNetworkActivity()
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(controller, animated: true, completion: nil)
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
            
    }
    
    //MARK: New user request button pressed
    @IBAction func newUser(_ sender: AnyObject) {
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.shared.open(url! as URL)
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        
        loginLabel.isHidden = true
        udacityLogoImageView.isHidden = true
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        
        loginLabel.isHidden = false
        udacityLogoImageView.isHidden = false
    }
    
  
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
 


// MARK: - LoginViewController (Configure UI)

    func configureUI() {
        configureTextField(usernameTextField,self)
        configureTextField(passwordTextField,self)
    }
 
    //MARK: Disables input and displays "busy" indicator while performing login.
    func startNetworkActivity() {
        activityIndicator.startAnimating()
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
    }
    
    //MARK: Re-enables input if necessary following login. Also hides "busy" indicator.
    func stopNetworkActivity() {
        activityIndicator.stopAnimating()
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        loginButton.isEnabled = true
    }
    

}


