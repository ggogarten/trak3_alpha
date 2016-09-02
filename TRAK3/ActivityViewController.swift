//
//  ActivityViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ActivityViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var sport = GlobalVariables.sharedManager.activitySport
    
    var units = GlobalVariables.sharedManager.units
    
    var user = PFUser.currentUser()
    
        
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var swimButtonOut: UIButton!
    
    @IBOutlet weak var bikeButtonOut: UIButton!
    
    @IBAction func preferencesButton(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier("showMoreButton", sender: self)
        
        
    }
    
    @IBAction func challengesButtonPress(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showChallengesButton", sender: self)
        
        
    }
    
   
    @IBAction func friendsButtonPress(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showSocialActivityButton", sender: self)
        
    }
    
    
    @IBOutlet weak var runButtonOut: UIButton!
    
    @IBAction func swimButtonPress(sender: AnyObject) {
        
        // set selected
        swimButtonOut.selected = true
        self.runButtonOut.selected = false
        self.bikeButtonOut.selected = false
        GlobalVariables.sharedManager.activitySport = "swim"
        print(GlobalVariables.sharedManager.activitySport)
        
        
    }
    
    
    @IBAction func bikeButtonPress(sender: AnyObject) {
        
        // set selected
        bikeButtonOut.selected = true
        self.swimButtonOut.selected = false
        self.runButtonOut.selected = false
        GlobalVariables.sharedManager.activitySport = "bike"
        print(GlobalVariables.sharedManager.activitySport)
        
    }
    
    
    
    @IBAction func runButtonPress(sender: AnyObject) {
        
        // set selected
        runButtonOut.selected = true
        self.swimButtonOut.selected = false
        self.bikeButtonOut.selected = false
        GlobalVariables.sharedManager.activitySport = "run"
        print(GlobalVariables.sharedManager.activitySport)
        
    }
    
    @IBOutlet weak var activityBackgroundPic: UIImageView!
    
    
    @IBAction func musicButtonPress(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "music:")!)
        
        
    }
    
    
    
    @IBOutlet weak var activitySportSelectorOut: UISegmentedControl!
    
    
    @IBAction func activitySportSelector(sender: AnyObject) {
        
        switch activitySportSelectorOut.selectedSegmentIndex
        {
        case 0:
            print("bike")
            self.sport = "bike"
            GlobalVariables.sharedManager.activitySport = sport
            activityBackgroundPic.image = UIImage(named: "backgroundBike.png")
            
        case 1:
            print("run")
            self.sport = "run"
            GlobalVariables.sharedManager.activitySport = sport
            activityBackgroundPic.image = UIImage(named: "newWorkoutPicture.png")
           
        default:
            break;
        }
        
        
    }

    
    @IBAction func startActivityPress(sender: AnyObject) {
        self.performSegueWithIdentifier("startNewActivity", sender: self)
    }
    
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    
    @IBOutlet weak var startActivityButton: UIButton!
    
    @IBAction func myWorkoutsButton(sender: AnyObject) {
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user)
        
        var sportSelected = activitySportSelectorOut.selectedSegmentIndex
        
        
        if sportSelected == 0 {
            
            GlobalVariables.sharedManager.activitySport = "bike"
            activityBackgroundPic.image = UIImage(named: "backgroundBike")
            
        } else {
            
            GlobalVariables.sharedManager.activitySport = "run"
            activityBackgroundPic.image = UIImage(named: "newWorkoutPicture")
           
        }
        
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 5.0
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        self.map.showsUserLocation = true
        self.map.mapType = MKMapType(rawValue: 0)!
        self.map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        
        if oldLocation != nil {
            
            if units == "Metric" {
                
                var speed = newLocation.speed
                var speedKph = String(format: "%.2f", speed * 3.6)
                
                if speed > 0 {
                    
//                    self.currentSpeedLabel.text = "\(speedKph)"
                    
                } else {
                    
//                    self.currentSpeedLabel.text = "0.0"
                    
                }
                
            } else {
                
                var speed = newLocation.speed
                var speedMph = String(format: "%.2f", speed * 2.2369363)
                
                if speed > 0 {
                    
//                    self.currentSpeedLabel.text = "\(speedMph)"
                    
                    
                } else {
                    
//                    self.currentSpeedLabel.text = "0.0"
                    
                    
                }
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
