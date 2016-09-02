//
//  MyWorkoutsViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/7/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyWorkoutsViewController: UIViewController {

    var selectedSport = "bike"
    
    var usernames = ""
    
    var userLocation = ""
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
   
    @IBOutlet weak var userLocationLabel: UILabel!
    
    
    @IBOutlet weak var sportsSelectorOut: UISegmentedControl!
    
    @IBOutlet weak var containerViewOut: UIView!
    
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    
    
    @IBAction func sportSelector(sender: AnyObject) {
    
        switch sportsSelectorOut.selectedSegmentIndex
        {
        case 0:
            print("bike")
            self.selectedSport = "bike"
            let childView = self.childViewControllers.last as! MyWorkoutsTableViewController
            childView.sport = self.selectedSport
           childView.loadObjects()
            
//            print("swim")
//            self.selectedSport = "swim"
//            let childView = self.childViewControllers.last as! MyWorkoutsTableViewController
//            childView.sport = self.selectedSport
//            
//            // tableView reloadData() does nothing have to use loadObjects() as childView
//                //reloadData will only reload the UITableView with whatever self.objects contains. To get the latest results from Parse, use //[self loadObjects].
//                //
//                //- Héctor Ramos over 3 years ago
            
            childView.loadObjects()
            
            
        case 1:
             print("run")
            self.selectedSport = "run"
            let childView = self.childViewControllers.last as! MyWorkoutsTableViewController
            childView.sport = self.selectedSport
            childView.loadObjects()
//        case 2:
           
        default:
            break; 
        }
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
     
            if segue.identifier == "containerMyWorkouts" {
                
                let controller = segue.destinationViewController as! MyWorkoutsTableViewController
                controller.sport = self.selectedSport
                print("segue happening after controller variables passed correctly!")
                
            }


}
}

