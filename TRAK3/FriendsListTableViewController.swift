//
//  FriendsListTableViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/12/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendsListTableViewController: PFQueryTableViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func queryForTable() -> PFQuery {
        
        let followQuery = PFQuery(className: "socialActivity")
        followQuery.cachePolicy = .NetworkElseCache
        followQuery.whereKey("type", equalTo: "follow")
        followQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        followQuery.includeKey("fromUser")
        followQuery.includeKey("toUser")
        print("social query ran")
        
        
//        var query: PFQuery =  PFUser.query()!
//        query.whereKey((PFUser.currentUser()), matchesKey: "fromUser", inQuery: followQuery)
//        print((PFUser.currentUser()?.objectId)!)
        
        
        print("query for users ran")
        
        return followQuery
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendsListTableViewCell
        
//        cell.usernameLabel.text = object?.objectForKey("username") as? String
        
        if let objects = objects {
            
            for object in objects {
                
//                need to convert to a pfobject below then start parsing, when that is do you can load username from object, this if code for users that current user follows.
                
                if let object = object as PFObject? {
                    
                    print(object.objectForKey("toUser"))
                    if let toUser = object.objectForKey("toUser"){
                        
                        cell.usernameLabel.text = toUser.username
                        
                        
                    }
                    
                    
                
                }
        
//                print(object)
                print("username set")
//                return cell
            }
        }
        return cell
        }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row + 1 > self.objects?.count{
            return 44
        }
        
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var socialActivity = PFObject(className:"socialActivity")
            socialActivity["fromUser"] = PFUser.currentUser()!
            socialActivity["type"] = "follow"
            
            let toUserObject = self.objectAtIndexPath(indexPath)
            print(toUserObject)
            
            socialActivity["toUser"] = toUserObject
            
            socialActivity.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    print("socialActivity has been saved")
                    
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
            
            print("follow succesful")
            self.tableView.reloadData()
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var follow = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Follow") { (UITableViewRowAction, NSIndexPath) in
            self.tableView.dataSource?.tableView?(self.tableView,commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
            return
        }

        follow.backgroundColor = UIColor.blueColor()
        
            return [follow]
            
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

}
