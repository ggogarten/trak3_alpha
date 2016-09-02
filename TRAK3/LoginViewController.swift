//
//  LoginViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import MapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var whoAmILabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if usernameField.text == "" || passwordField.text == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password.")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            var errorMessage = "Please try again later"
            
            PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil {
                    // Do stuff after successful login.
                    
                    print("login succesful")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("profile")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                } else {
                    
                    // The login failed. Check error to see why.
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                        
                        print("login failed")
                        print(error)
                        self.displayAlert("Failed Login", message: errorMessage)
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func signupButton(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("signup")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func loginWithFacebookButton(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"]) { (user: PFUser?, error: NSError?) in
            
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("profile")
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                } else {
                    print("User logged in through Facebook!")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("activityView")
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print(PFUser.currentUser())
//        whoAmILabel.text = PFUser.currentUser()?.username
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("view will appear")
        if PFUser.currentUser() != nil {
//            print("view did not segue")
//            self.performSegueWithIdentifier("loggedIn", sender: self)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("activityView")
            self.presentViewController(vc, animated: true, completion: nil)
            
        } else {
            
            
        }
        
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
