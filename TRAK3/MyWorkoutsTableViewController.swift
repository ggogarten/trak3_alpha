//
//  MyWorkoutsTableViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/11/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyWorkoutsTableViewController: PFQueryTableViewController {

    
    var sport = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
            
            self.tableView.reloadData()
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "activity")
        query.cachePolicy = .NetworkElseCache
        query.orderByDescending("createdAt")
        query.whereKey("createdBy", equalTo: PFUser.currentUser()!)
        query.whereKey("sport", equalTo: sport)
        return query
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutsCell", forIndexPath: indexPath) as! MyWorkoutsTableViewCell
        
        print("cell found")
//        cell.activityIdLabel!.text = object!.objectId
        cell.activityDateLabel!.text = String(object!.valueForKey("activityTimeStamp"))
        print(object!.valueForKey("activityTimeStamp"))
        cell.activityDistanceLabel!.text = String(object!.valueForKey("distance"))
        cell.activityTimeLabel!.text = String(object!.valueForKey("duration"))
        cell.averagePaceLabel?.text = String?("Coming Soon")
        

        let imageFile = object?.objectForKey("activityPicture") as? PFFile
        
        cell.activityPicture.image = UIImage(named: "selfie.jpg")
        
        imageFile?.getDataInBackgroundWithBlock({ (imageFile, error) in
            print("picture downloaded")
            cell.activityPicture.image = UIImage(data: imageFile!)
            
        })
        
    
    
        return cell
        
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row + 1 > self.objects?.count
        {
            return 44
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row + 1 > self.objects?.count
        {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else
        {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
//        if segue.identifier == "showDetail"
//        {
//            let indexPath = self.tableView.indexPathForSelectedRow
//            let detailVC = segue.destinationViewController as! PreviewViewController
//            let object = self.objectAtIndexPath(indexPath)
//            detailVC.titleString = object?.objectForKey("title") as! String
//            detailVC.imageFile = object?.objectForKey("image") as! PFFile
//            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
//        }         
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
     self.tableView.reloadData()
        
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
