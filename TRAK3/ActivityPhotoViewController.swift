//
//  ActivityPhotoViewController.swift
//  TRAK3
//
//  Created by George Gogarten on 7/18/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse

class ActivityPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var activityId = String()
    
    var imageTaken = UIImage()
    
    var activitySelfieImage = UIImage()
    
    @IBOutlet weak var activitySelfie: UIImageView!
    
    
    @IBAction func takeYourSelfie(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.cameraDevice = UIImagePickerControllerCameraDevice.Front
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.activitySelfie.image = image
        print("activitySelfieSet")
        self.activitySelfieImage = activitySelfie.image!
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
//        let parentVC = (self.parentViewController)! as! ActivitySummaryViewController
//        parentVC.activityPicture = activitySelfieImage

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
