//
//  ActivitySummaryViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import MapKit
import HealthKit
import CoreLocation

class ActivitySummaryViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityTime = 0.0
    
    var activityDistance = 0.0
    
    var locations = [CLLocation]()
    
    var activityId = String()
    
    var parseLocations = [PFGeoPoint]()
    var locationTimeStamps = [NSDate]()
    var locationSpeeds = [Double]()
    var sport = String()
    var inProgress = Bool()
    
    var activityTimeStamp = NSDate()
    var startPoint = CLLocation()
    var endPoint = CLLocation()
    
    var units = GlobalVariables.sharedManager.units
    
    @IBOutlet weak var backgroundPicture: UIImageView!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var activityNameTextField: UITextField!
    
    @IBOutlet weak var activityDateLabel: UILabel!
    
    @IBOutlet weak var activityTimeLabel: UILabel!
    
    @IBOutlet weak var activityDistanceLabel: UILabel!
    
    @IBOutlet weak var activityAverageSpeedLabel: UILabel!
    
    @IBOutlet weak var activitySportLabel: UILabel!
    
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    @IBOutlet weak var averagePaceUnitLabel: UILabel!
    
    
    
//    @IBOutlet weak var photoMapSelectorOut: UISegmentedControl!
    
//    @IBAction func photoMapSelector(sender: AnyObject) {
//        
//        switch photoMapSelectorOut.selectedSegmentIndex
//        
//        {
//        case 0:
//            activityPhotoViewOut.hidden = false
//            activityMapViewOut.hidden = true
//        case 1:
//            activityPhotoViewOut.hidden = true
//            activityMapViewOut.hidden = false
//        default:
//            break; 
//        }
//        
//        
//        
//        
//    }
    
    @IBAction func saveButtonPress(sender: AnyObject) {
        
//        print(activityPicture)
        
//        var activity = PFObject(className:"activity")
//        activity["duration"] = time
//        activity["username"] = user?.username
//        activity.objectId = self.activityId
        
        
//        activityPictures = self.activityPhotoView
        
//        let imageData = UIImageJPEGRepresentation(activityPhotoViewOut.image!, 1.0)

//        let imageFile = PFFile(name: "image.png", data: imageData!)
        
//        activity["activityPicture"] = imageFile
//       
//        
//        activity.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
////                self.activityIndicator.stopAnimating()
////                UIApplication.sharedApplication().endIgnoringInteractionEvents()
//                print("activity has been saved")
//                
//                //                    var query = PFQuery(className:"activity")
//                //                    query.cachePolicy = .CacheElseNetwork
//                //                    query.whereKey("username", equalTo: self.user!)
////                self.activityId = activity.objectId!
//                print("activity kept")
        self.inProgress = false
        self.performSegueWithIdentifier("activityEnded", sender: self)
        
//    }
//        }
    }
    
    @IBAction func discardButtonPress(sender: AnyObject) {
      
        let query = PFQuery(className: "activity")
        query.whereKey("objectId", equalTo: activityId)
        query.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, error: NSError?) in
            for object in object! {
                object.deleteInBackground()
                print("activity deleted")
                self.inProgress = false
                self.performSegueWithIdentifier("activityEnded", sender: self)
            }
    })
    
    
    }
    
    
    var activitySelfieImage = UIImage()
  
    @IBOutlet weak var activitySelfieImageView: UIImageView!
    
    
    @IBAction func activitySelfieButton(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.cameraDevice = UIImagePickerControllerCameraDevice.Front
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.activitySelfieImageView.image = image
        print("activitySelfieSet")
        self.activitySelfieImage = activitySelfieImageView.image!
        self.dismissViewControllerAnimated(true, completion: nil)
        var activity = PFObject(className:"activity")
        //        activity["duration"] = time
        //        activity["username"] = user?.username
        activity.objectId = self.activityId
        
        
        var activityPicture = activitySelfieImage
        
        let imageData = UIImageJPEGRepresentation(activityPicture, 1.0)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        activity["activityPicture"] = imageFile
        
        activity.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                print("activity has been saved")
                
                
                print("activity kept")
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(locations)
//        activityTimeLabel.text = String(self.activityTime)
//        activityDistanceLabel.text = String(self.activityDistance)
//        activityAverageSpeedLabel.text = String(self.activityDistance/self.activityTime)
//        activitySportLabel.text = sport
//        activityNameTextField.text = activityId
        map.delegate = self
//        activityMapViewOut.hidden = true
        configureView()
        
        if sport == "bike" {
            
//            sportIcon.image = UIImage(named: "cycleWhiteLogo")
            backgroundPicture.image = UIImage(named: "backgroundBike")
        } else {
            
            if sport == "run" {
                
//                sportIcon.image = UIImage(named: "runningWhiteIcon")
                backgroundPicture.image = UIImage(named: "newWorkoutPicture.png")
            }
            
        }

        
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        
        let meters = activityDistance
        let yards = meters * 1.09361
        let miles = meters * 0.000621371
        let kilometers = meters / 1000
        let hours = activityTime / 3600
        
       
        if units == "Metric" {
        
        let activityDistanceHK = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: activityDistance)
//        activityDistanceLabel.text = String(activityDistanceHK)
        activityDistanceLabel.text = String(format: "%.2f", kilometers)
        
        
//        distanceLabel.text = String(format: "%.2f", kilometers)
        distanceUnitLabel.text = "Kilometers"
        
        } else {
            
            activityDistanceLabel.text = String(format: "%.2f", miles)
            distanceUnitLabel.text = "Miles"
            
            
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        activityDateLabel.text = dateFormatter.stringFromDate(activityTimeStamp)
        
        
        if activityTime > 3600 {
            print("time is greater than 3600")
            var seconds = activityTime
            var minutes = activityTime / 60
            var hours = activityTime / 3600
            
            var secondsIntCalc = Int(minutes) * 60
            print(secondsIntCalc)
            print(seconds)
            var secondsInt = Int(seconds) - secondsIntCalc
            print(secondsInt)
            var minutesIntCalc = Int(hours) * 60
            var minutesInt = Int(minutes) - minutesIntCalc
            print(minutesInt)
            var hoursInt = Int(hours)
            print(hoursInt)
            
//            let activityTimeHK = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: activityTime)
//            let activityTimeHKHours = HKQuantity(unit: HKUnit.hourUnit(), doubleValue: activityTime)
            activityTimeLabel.text = String(format:"%02i:%02i:%02i", hoursInt, minutesInt, secondsInt)
//            activityTimeLabel.text = String(activityTimeHKHours)

            } else {
            
            if activityTime > 60 {
                print("time is greater than 60")
            
            var seconds = activityTime
            var minutes = activityTime / 60
            var hours = activityTime / 3600
            
            var secondsIntCalc = Int(minutes) * 60
            print(secondsIntCalc)
            print(seconds)
            var secondsInt = Int(seconds) - secondsIntCalc
            print(secondsInt)
            var minutesInt = Int(minutes)
            print(minutesInt)
                
//                var hoursInt = Int(hours)
            
                
            
//                let activityTimeHK = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: activityTime)
//                let activityTimeHKMinutes = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: minutes)
                activityTimeLabel.text = String(format:"%02i:%02i", minutesInt, secondsInt)
//                activityTimeLabel.text = String(activityTimeHKMinutes)
            
            }
            else {
                print("time is less than 60")
                print(activityTime)
                var seconds = self.activityTime
                var minutes = self.activityTime / 60
                var hours = self.activityTime / 3600
                var secondsIntCalc = Int(minutes) * 60
                print(secondsIntCalc)
                print(seconds)
                var secondsInt = Int(seconds) - secondsIntCalc
                print(secondsInt)
                var minutesInt = Int(minutes)
                print(minutesInt)
                
//                let activityTimeHK = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: activityTime)
//                let activityTimeHKSeconds = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: activityTime)
                
//                activityTimeLabel.text = String(format:"%02i", secondsInt)
                activityTimeLabel.text = String(format:"%02i:%02i", minutesInt, secondsInt)
//                activityTimeLabel.text = String(activityTime)
//                activityTimeLabel.text = String(activityTimeHKSeconds)
                
            }
            
        }
        
        if units == "Metric" {

        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: activityDistance / activityTime)
        var averageSpeed = (kilometers / hours)
        print("metric")
        print(averageSpeed)
        activityAverageSpeedLabel.text = String(format:"%.2f", averageSpeed)
        averagePaceUnitLabel.text = "Kph"
            
    } else {
    
    var averageSpeed = (miles / hours)
    print(averageSpeed)
    activityAverageSpeedLabel.text = String(format:"%.2f", averageSpeed)
    averagePaceUnitLabel.text = "Mph"
    
    }
//        activityAverageSpeedLabel.text = paceQuantity.description
//        activityAverageSpeedLabel.text = String(activityDistance / (activityTime / 3600))
        
        loadMap()
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
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
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
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "activityMapSegue") {
            if let childViewController = segue.destinationViewController as? ActivityMapViewController {
//            DestViewController.LabelText = TextField.text
            childViewController.locations = locations
            }
            
            
        } else {
            
            if (segue.identifier == "activityPhotoSegue") {
                if let childViewController = segue.destinationViewController as? ActivityPhotoViewController {
                childViewController.activityId = activityId
//                    print(activityPicture)
                    print(activityId)
                    print("delegate set")
                    
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
