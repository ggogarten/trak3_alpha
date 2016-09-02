//
//  TrainingViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import ParseUI
import AVFoundation
import HealthKit



class TrainingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var backgroundPictureOut: UIImageView!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func backButtonPress(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self

        // Do any additional setup after loading the view.
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
