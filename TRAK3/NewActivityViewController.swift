//
//  NewActivityViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import MapKit
import Parse
import AVFoundation
import HealthKit
import CoreLocation

class NewActivityViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var inProgress = false
    
    var activityTimeStamp = NSDate()
    
    var activityId = String()
    
    @IBOutlet weak var map: MKMapView!
    
    var units = GlobalVariables.sharedManager.units
    
    var sport = GlobalVariables.sharedManager.activitySport
    
    var locationManager = CLLocationManager()
    
    var parseLocations = [PFGeoPoint]()
    
    var locationTimeStamps = [NSDate]()
    
    var locationSpeeds = [Double]()
    
    var user = PFUser.currentUser()
    
    var timer = NSTimer()
    
    var time = 0.0
    
    var distance = 0.0
    
    var startPoint = CLLocation()
    
    var endPoint = CLLocation()
    
    var activityStarted = true
    
    var locations = [CLLocation]()
    
    var clLocationsStringsArray = [String]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var backgroundPicture: UIImageView!
    
    @IBOutlet weak var sportLabel: UILabel!
    
    @IBOutlet weak var sportIcon: UIImageView!
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBOutlet weak var activitySpeedLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var distanceTitleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var unitsLabel: UILabel!
    
    @IBAction func pauseActivityButtonPress(sender: AnyObject) {
        
        if activityStarted == true {
            
            timer.invalidate()
            activityStarted = false
            pauseOrPlayButtonOut.setTitle("Continue", forState: UIControlState.Normal)
            pauseOrPlayButtonOut.setImage(UIImage(named: "playButtonIcon"), forState: UIControlState.Normal)
            
            
        } else {
            
            activityStarted = true
            pauseOrPlayButtonOut.setTitle("Pause", forState: UIControlState.Normal)
            pauseOrPlayButtonOut.setImage(UIImage(named: "pauseButtonIcon"), forState: UIControlState.Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("increaseTimer"), userInfo: nil, repeats: true)
            
            
            
            
        }
        
        
    }
    
    
    
    @IBAction func musicButtonPress(sender: AnyObject) {
        
         UIApplication.sharedApplication().openURL(NSURL(string: "music:")!)
        
    }
    
    
    
    @IBOutlet weak var pauseOrPlayButtonOut: UIButton!
    
    
    @IBAction func endActivityButtonPress(sender: AnyObject) {
        
       locationManager.stopUpdatingLocation()
        
        if activityStarted == true {
            
            timer.invalidate()
            activityStarted = false
            inProgress = true
            var activity = PFObject(className:"activity")
            activity["duration"] = time
            print("duration set")
            activity["username"] = user?.username
            print("username set")
            activity["distance"] = distance
            print("distance set")
            activity["parseLocations"] = parseLocations
            print("parseLocations set")
            activity["locationTimeStamp"] = locationTimeStamps
            print("locationTimeStamp set")
            activity["locationSpeed"] = locationSpeeds
            print("locationSpeed set")
            activity["sport"] = sport
            print("sport set")
            activity["inProgress"] = inProgress
            print("sport set")
            activity["createdBy"] = PFUser.currentUser()
            
            activity["clLocations"] = clLocationsStringsArray
            //            activity["startPoint"] = locations[0]
            //            activity["endPoint"] = locations.last
            
            if let date = locationTimeStamps.last {
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var dateString = dateFormatter.stringFromDate(date)
                
                activity["activityTimeStamp"] = dateString as? String
                
            } else {}
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            activity.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("activity has been saved")
                    
                    //                    var query = PFQuery(className:"activity")
                    //                    query.cachePolicy = .CacheElseNetwork
                    //                    query.whereKey("username", equalTo: self.user!)
                    self.activityId = activity.objectId!
                    self.performSegueWithIdentifier("endShowActivityDetail", sender: self)
                    // network and then on disk.
                    
                } else {
                    
                    // The network was inaccessible and we have no cached data for
                    // this query.
                    
                    
                    
                    // The object has been savedd
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("save failed")
                    
                    // There was a problem, check error.description
                }
            }
            
        

            
            } else {
            
            timer.invalidate()
            activityStarted = false
            inProgress = true
            
            var activity = PFObject(className:"activity")
            activity["duration"] = time
            activity["username"] = user?.username
            activity["distance"] = distance
            activity["parseLocations"] = parseLocations
            activity["locationTimeStamp"] = locationTimeStamps
            activity["locationSpeed"] = locationSpeeds
            activity["sport"] = sport
            activity["inProgress"] = inProgress
            activity["createdBy"] = PFUser.currentUser()
            
            activity["clLocations"] = clLocationsStringsArray
//            activity["startPoint"] = locations[0]
//            activity["endPoint"] = locations.last
            
            if let date = locationTimeStamps.last {
                
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var dateString = dateFormatter.stringFromDate(date)
           
            activity["activityTimeStamp"] = dateString as? String
           
            } else {}
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            activity.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("activity has been saved")
                    
//                    var query = PFQuery(className:"activity")
//                    query.cachePolicy = .CacheElseNetwork
//                    query.whereKey("username", equalTo: self.user!)
                    self.activityId = activity.objectId!
                    self.performSegueWithIdentifier("endShowActivityDetail", sender: self)
                    // network and then on disk.
                    
                } else {
                    
                    // The network was inaccessible and we have no cached data for
                    // this query.
             
    
                    
                    // The object has been savedd
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("save failed")

                    // There was a problem, check error.description
                }
            }
        
        }
    }
    
    
    @IBAction func backToNewActivityButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func increaseTimer(){
        
        time = time + 1
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if time > 3600 {
            
            timeLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else {
            
            timeLabel.text = String(format:"%02i:%02i", minutes, seconds)
            
        }
        
    }
    


func mapRegion() -> MKCoordinateRegion {
    let initialLoc = self.locations[0]
    var minLat = initialLoc.coordinate.latitude
    var minLng = initialLoc.coordinate.longitude
    var maxLat = minLat
    var maxLng = minLng
    
    for location in locations {
        minLat = min(minLat, location.coordinate.latitude)
        minLng = min(minLng, location.coordinate.longitude)
        maxLat = max(maxLat, location.coordinate.latitude)
        maxLng = max(maxLng, location.coordinate.longitude)
        
    }
    
    return MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: minLat, longitude: minLng),
        span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*0.6,
            longitudeDelta: (maxLng - minLng)*0.6))
    
//    return MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
//            longitude: (minLng + maxLng)/2),
//        span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
//            longitudeDelta: (maxLng - minLng)*1.1))
    
}

func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    
    let polyline = overlay as! MKPolyline
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.lineWidth = 8
    renderer.strokeColor = UIColor.blackColor()
    print("renderer called")
    return renderer
    
}

func polyline() -> MKPolyline {
    var coords = [CLLocationCoordinate2D]()
    
    for location in locations {
        coords.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude))
    }
    
    return MKPolyline(coordinates: &coords, count: locations.count)
}

func loadMap() {
    if locations.count > 0 {
        map.hidden = false
        
        // Set the map bounds
        map.region = mapRegion()
        
        // Make the line(s!) on the map
        self.map.addOverlay(polyline())
        
        print("map overlaid")
    } else {
        // No locations were found!
        map.hidden = true
        
        UIAlertView(title: "Error",
                    message: "Sorry, this run has no locations saved",
                    delegate:nil,
                    cancelButtonTitle: "OK").show()
    }
}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(user)
//        map.delegate = self
        
        unitsLabel.text = units
//        sportLabel.text = sport
        
        if sport == "bike" {
            
            sportIcon.image = UIImage(named: "cycleWhiteLogo")
            backgroundPicture.image = UIImage(named: "backgroundBike")
            
        } else {
            
            if sport == "run" {
                
                sportIcon.image = UIImage(named: "runningWhiteIcon")
                backgroundPicture.image = UIImage(named: "newWorkoutPicture.png")
            }
            
        }
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 5.0
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        map.delegate = self
//        map.mapType = MKMapType.Satellite
        map.mapType = MKMapType.Standard
//        map.showsUserLocation = true
        
        
        if activityStarted == true {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("increaseTimer"), userInfo: nil, repeats: true)
            pauseOrPlayButtonOut.setImage(UIImage(named: "pauseButtonIcon"), forState: UIControlState.Normal)
            
        } else {}
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        
        if oldLocation != nil {
            
            if activityStarted == true {
                
                self.locations.append(newLocation)
                let locationAsString = String(newLocation)
                self.clLocationsStringsArray.append(locationAsString)
                
                let latitude = newLocation.coordinate.latitude
                let longitude = newLocation.coordinate.longitude
                let parseLocation = PFGeoPoint(latitude: latitude, longitude: longitude)
                parseLocations.append(parseLocation)
                let locationTimeStamp = newLocation.timestamp
                locationTimeStamps.append(locationTimeStamp)
                let locationSpeed = newLocation.speed
                locationSpeeds.append(locationSpeed)
                print(parseLocation)
                print(locationSpeed)
                print(locationTimeStamp)
                
                
                distance = distance + newLocation.distanceFromLocation(oldLocation)
                
                let meters = distance
                let yards = meters * 1.09361
                let miles = meters * 0.000621371
                let kilometers = meters / 1000
                let hours = time / 3600
                
                print(distance)
                map.region = mapRegion()
                loadMap()
                
                
                if units == "Metric" {
                    
                    var speed = newLocation.speed
                    var speedKph = String(format: "%.2f", speed * 3.6)
                    var speedKphInt = Int(speed * 3.6)
                    var speedKphFloat = speed * 3.6
                    
                    if speed > 0 {
                        
                        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
                        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: meters / time)
                        
//                        if distance > 999 {
                        
                            let activityDistanceHK = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: meters)
                            
                            distanceLabel.text = String(format: "%.2f", kilometers)
                            distanceTitleLabel.text = "KM"
                            
//                            self.currentSpeedLabel.text = "\(speedKphInt)"
                            currentSpeedLabel.text = String(format: "%.2f", speedKphFloat)
                            activitySpeedLabel.text = "Kph"
                            
//                        } else {
//                            
//                        
//                        let activityDistanceHK = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: meters)
//                       
////                        distanceLabel.text = String(activityDistanceHK)
//                        distanceLabel.text = String(format: "%.1f", meters)
//                        distanceTitleLabel.text = "Meters"
////                        self.currentSpeedLabel.text = "\(speedKphInt)"
//                            currentSpeedLabel.text = String(format: "%.1f", speedKphFloat)
//                            activitySpeedLabel.text = "KM/H"
//                        }
                    
                    }
                    } else {
                    
                    var speed = newLocation.speed
                    var speedMph = String(format: "%.2f", speed * 2.2369363)
                    
                    
                    if speed > 0 {
                        
                        self.currentSpeedLabel.text = "\(speedMph)"
                        activitySpeedLabel.text = "Mph"
                        self.distanceLabel.text = String(format:"%.2f", miles)
                        distanceTitleLabel.text = "Miles"
                        
                    } else {
                        
                        self.currentSpeedLabel.text = "0.0"
//                        self.distanceLabel.text = String(format:"%3.f", miles)
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "endShowActivityDetail" {
            
            
        let controller = segue.destinationViewController as! ActivitySummaryViewController
                        controller.activityId = self.activityId
                        controller.activityTime = self.time
                        controller.activityDistance = self.distance
                        controller.parseLocations = self.parseLocations
                        controller.locationTimeStamps = self.locationTimeStamps
                        controller.locationSpeeds = self.locationSpeeds
                        controller.sport = self.sport
                        controller.inProgress = self.inProgress
                        controller.locations = self.locations
                        controller.activityTimeStamp = self.activityTimeStamp
                        controller.startPoint = self.startPoint
                        controller.endPoint = self.endPoint
            
            
            
            print("segue happening after controller variables passed correctly!")
                        
            
                    
                    // Results were successfully found, looking first on the
                        } else {
    
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


