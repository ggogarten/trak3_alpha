//
//  SignupViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    @IBAction func signupButton(sender: AnyObject) {
        
        if usernameField.text == "" || passwordField.text == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password.")
            
        } else {
            
            if passwordField.text != confirmPasswordField.text {
                
                displayAlert("Error in form", message: "Passwords must match!")
                
            } else {
                
                activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                var errorMessage = "Please try again later"
                
                let user = PFUser()
                user.username = usernameField.text
                user.password = passwordField.text
                user["email"] = emailField.text
                
                
                user.signUpInBackgroundWithBlock({ (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        // Signup successful
                        
                        print("Signup Succesful")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("profile")
                        self.presentViewController(vc, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Signup", message: errorMessage)
                    }
                })
            }
        }
    }
    
    
   
        
    
    @IBAction func backToLogin(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(PFUser.currentUser())
        
        self.usernameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
