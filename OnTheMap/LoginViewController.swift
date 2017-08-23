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
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        
        var parameters = [String:String]()
        parameters["username"] = usernameTextField.text!
        parameters["password"] = passwordTextField.text!
        
        guard usernameTextField.text!.isEmpty == false && passwordTextField.text!.isEmpty == false else {
            showAlert(sender, message: UdactiyClient.ErrorMessages.noInputError)
            return
        }
        
        Connectivity.isInternetAvailable(webSiteToPing: nil) { (success) in
            guard success else {
                self.stopNetworkActivity()
                self.passwordTextField.text = ""
                self.showAlert(sender, message: UdactiyClient.ErrorMessages.networkError)
                return
            }
        }
            
        UdactiyClient.sharedInstance().getUdacityUserInfo(parameters) { (sucess, error) in
            
            guard sucess else {
                performUIUpdatesOnMain {
                    self.showAlert(sender, message: UdactiyClient.ErrorMessages.loginError)
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
    


// MARK: - LoginViewController: UITextFieldDelegate


    
    // MARK: UITextFieldDelegate
    
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
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
 


// MARK: - LoginViewController (Configure UI)

    func configureUI() {
        
        /*
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        */
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
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


