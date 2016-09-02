//
//  ActivityMapViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/18/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import MapKit
import HealthKit
import CoreLocation

class ActivityMapViewController: UIViewController, MKMapViewDelegate {

    var locations = [CLLocation]()
    
    var startPoint = CLLocation()
    var endPoint = CLLocation()

    var activityId = String()

    var locationTimeStamps = [NSDate]()
    var locationSpeeds = [Double]()
    var sport = String()

    
    @IBOutlet weak var map: MKMapView!
    
    var activityTime = 0.0
    
    var activityDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locations)
        map.delegate = self
        configureView()

        // Do any additional setup after loading the view.
    }

    func configureView() {
        let activityDistanceHK = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: activityDistance)
//        activityDistanceLabel.text = String(activityDistanceHK)
        
        //        let dateFormatter = NSDateFormatter()
        //        dateFormatter.dateStyle = .MediumStyle
        //        dateLabel.text = dateFormatter.stringFromDate(run.timestamp)
        
        
        let activityTimeHK = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: activityTime)
//        activityTimeLabel.text = String(activityTimeHK)
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: activityDistance / activityTime)
//        activityAverageSpeedLabel.text = paceQuantity.description
        
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
        renderer.lineWidth = 4
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
