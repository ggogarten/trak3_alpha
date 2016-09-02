//
//  MoreViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
  
    var units = GlobalVariables.sharedManager.units
    
    @IBAction func profileButton(sender: AnyObject) {
        
        GlobalVariables.sharedManager.profileFromMore = true
        
        
        self.performSegueWithIdentifier("moreToProfile", sender: self)
        
        
        
    }
    
    @IBOutlet weak var unitsLabelOut: UILabel!
    
    @IBAction func locationSettingsButton(sender: AnyObject) {
        
//        UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=General")!)
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)

        
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
        }
        
    }
    
    
    @IBOutlet weak var unitsButtonOut: UIButton!
    
    @IBAction func unitsButton(sender: AnyObject) {
        
        if unitsButtonOut.tag == 270 {
           
            unitsButtonOut.tag = 271
            unitsLabelOut.text = "Imperial"
            GlobalVariables.sharedManager.units = "Imperial"
            print(unitsButtonOut.tag)

        } else  if unitsButtonOut.tag == 271 {

            unitsButtonOut.tag = 270
            unitsLabelOut.text = "Metric"
            GlobalVariables.sharedManager.units = "Metric"
            print(unitsButtonOut.tag)
        }
        
    }
    
    @IBAction func healthKitSettingsButton(sender: AnyObject) {
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(unitsButtonOut.tag)
        
        
    var userUnits = self.units
//    if userUnits == "Metric" {
//        
//        unitsButtonOut.tag = 270
//        unitsLabelOut.text = "Metric"
//        
//            
//        }
//        
//        unitsButtonOut.tag = 271
//        unitsLabelOut.text = "Imperial"

    unitsLabelOut.text = units
        
    }

        // Do any additional setup after loading the view.
    

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
