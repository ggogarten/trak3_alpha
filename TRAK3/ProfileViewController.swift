//
//  ProfileViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var units = GlobalVariables.sharedManager.units
    
    var userUnits = String()
    
    var pickOption = [Int]()
    
    var agePickOption = [Int]()
    
    var genderPickOption = ["Male","Female"]
    
    var weightPickOption = [Int]()
    
    var weight = 0
    
    @IBAction func unitsSwitch(sender: AnyObject) {
        
        if unitsSwitchOut.on {
            
            units = "Imperial"
            unitsLabelOut.text = "Imperial"
            unitsSwitchOut.setOn(true, animated: true)
            
            
        } else {
                
            units = "Metric"
            unitsLabelOut.text = "Metric"
            unitsSwitchOut.setOn(false, animated: true)            }
        
    }
   
    @IBOutlet weak var unitsSwitchOut: UISwitch!
    
    @IBOutlet weak var unitsLabelOut: UILabel!
   
    
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    
    
    @IBAction func closeButton(sender: AnyObject) {
        
        if GlobalVariables.sharedManager.profileFromMore == true {
        
        self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            PFUser.logOut()
            
        }
        
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        
        print(PFUser.currentUser())
        PFUser.logOut()
        print("logout succesful")
        print(PFUser.currentUser())
        let currentUser = PFUser.currentUser() // this will now be nil
        print(PFUser.currentUser())
        FBSDKLoginManager().logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(vc, animated: true, completion: nil)

        
        
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if firstNameField.text == "" || lastNameField.text == "" || ageField.text == "" || genderField.text == "" {
            
            displayAlert("Error in form", message: "Please fill in all fields.")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            var errorMessage = "Please try again later"
            
            let user = PFUser.currentUser()!
            
            user["FirstName"] = firstNameField.text
            user["LastName"] = lastNameField.text
            user["Age"] = ageField.text
            user["sex"] = genderField.text
            user["preferredUnits"] = units
            print(units)
            user["weight"] = weightField.text
            
            user.saveInBackgroundWithBlock({ (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    // Signup successful
//                    self.displayAlert("Save Succesful", message: "Please ok to continue.")
                    
                    
                    
                    print("Save Succesful")
                    
                    self.performSegueWithIdentifier("mainScreen", sender: self)
                    print("Segue performed")
//                    self.dismissViewControllerAnimated(true, completion: {
                    
//                    })
                    
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                        
                    }
                    
                    self.displayAlert("Save Failed", message: errorMessage)
                }
                
                
                
            })
            
        }

    }
    
    func getUserInfo() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name"])
        graphRequest.startWithCompletionHandler { (connection, results, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = results as? [String: AnyObject] {
                
                PFUser.currentUser()!["FirstName"] = result["first_name"]
                
                do {
                    try PFUser.currentUser()?.save()
                } catch let ex {
                    print(ex)
                }
                
                self.nameLabel.text = result["name"] as? String
                
                self.firstNameField.text = result["first_name"] as? String
                self.lastNameField.text = result["last_name"] as? String
                PFUser.currentUser()!["email"] = result["email"]
                self.ageField.text = PFUser.currentUser()!["Age"] as? String
                self.genderField.text = PFUser.currentUser()!["sex"] as? String
                
                self.weightField.text = PFUser.currentUser()!["weight"] as? String
                
                let userId = result["id"] as! String
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
//                print()
//                self.unitsLabelOut.text = PFUser.currentUser()!["preferredUnits"] as? String
                
//                if self.unitsLabelOut.text == "Imperial" {
//                    self.unitsSwitchOut.setOn(true, animated: true)
//                }
                
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl),
                    data = NSData(contentsOfURL: fbpicUrl) {
                    self.profilePic.image = UIImage(data: data)
                    let imageFile:PFFile = PFFile(data: data)!
                    PFUser.currentUser()?["profilePicture"] = imageFile
                    do {
                    
//                        try PFUser.currentUser()?.save()
                        
                    } catch let ex {
                        print(ex)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userUnits = units
        
//        if unitsSwitchOut.on {
//            print("units switch on")
//            units = "Imperial"
//            unitsLabelOut.text = "Imperial"
//            unitsSwitchOut.setOn(true, animated: true)
//            
//            
//        } else {
//            print("units switch off")
//            units = "Metric"
//            unitsLabelOut.text = "Metric"
//            unitsSwitchOut.setOn(false, animated: true)
//        }
    
    
        self.pickOption += 1...100
        self.agePickOption += 1...130
        self.weightPickOption += 20...300
        
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.ageField.delegate = self
        self.genderField.delegate = self
        self.weightField.delegate = self
        
        getUserInfo()
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        ageField.inputView = pickerView
        
        let genderPickerView = UIPickerView()
        
        genderPickerView.delegate = self
        
        genderField.inputView = pickerView
        
        let weightPickerView = UIPickerView()
        
        weightPickerView.delegate = self
        
        weightField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        
//        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.tappedToolBarBtn))
        
//        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(ViewController.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Pick one number"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace], animated: true)
        
        ageField.inputAccessoryView = toolBar
        genderField.inputAccessoryView = toolBar
        weightField.inputAccessoryView = toolBar
        
        func updatePicker(){
            pickerView.reloadAllComponents()
        }
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
    
    func donePressed(sender: UIBarButtonItem) {
        
        ageField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        ageField.text = "one"
        
        ageField.resignFirstResponder()
        genderField.resignFirstResponder()
        weightField.resignFirstResponder()
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickOption.count
        
        if ageField.isFirstResponder(){
            return pickOption.count
        }else if genderField.isFirstResponder(){
            return genderPickOption.count
        } else {
            return weightPickOption.count
        }
    }


    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return String(pickOption[row])
        if ageField.isFirstResponder(){
            return String(pickOption[row])
        }else if genderField.isFirstResponder(){
            return String(genderPickOption[row])
        } else {
            if units == "Metric" {
                return String(weightPickOption[row]) + " Kg"
            } else {
                return String(weightPickOption[row]) + " Lb"
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        ageField.text = String(pickOption[row]) + " years old"
        if ageField.isFirstResponder(){
            ageField.text = String(pickOption[row]) + " years old"
        }else if genderField.isFirstResponder(){
            genderField.text = String(genderPickOption[row])
        } else {
            weightField.text = String(weightPickOption[row])
            if units == "Metric" {
                weightField.text = String(weightPickOption[row]) + " Kg"
//                self.weight = weightPickOption[row]
                
            } else {
                weightField.text = String(weightPickOption[row]) + " Lb"
            }

        }
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
