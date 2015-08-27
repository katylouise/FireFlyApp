//
//  TimelineTableViewController.swift
//  FireFly
//
//  Created by Rebecca Appleyard on 26/08/2015.
//  Copyright (c) 2015 Firefly. All rights reserved.
//

import UIKit
import Parse
import Bolts
import MobileCoreServices

class TimelineTableViewController:
UITableViewController {
    var timelineData = [UIImage] ()
    
    func loadData() {
        timelineData.removeAll()
        println("\(timelineData.count)")
        
        var query = PFQuery(className:"Images")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    let userPicture = object["imageFile"] as! PFFile
                    userPicture.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            self.timelineData.append(image!)
                            
                            self.tableView.reloadData()
                            println("reloaded")
                        }
                    })
                }
            }
            println("string-check!")

        }
//        
//        var anotherPhoto = PFObject(className: "Images")
//        let findTimelineData = anotherPhoto["Images"] as! PFFile
//        
//        findTimelineData.getDataInBackgroundWithBlock {
//            //this request happens asynchronously
//            (imageData: NSData?, error:NSError?) -> Void in
//            //changed arguments to pass build
//            
//            if (error == nil) {
//                for object in imageData! {
//                    self.timelineData.addObject(object)
//                }
//                
//                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
//                self.timelineData = array.mutableCopy() as! NSMutableArray //changed this line to pass build
//                
//                self.tableView.reloadData()
//            }
//        }
    }
    

  override func viewDidAppear(animated: Bool) {
    self.loadData()
    println("\(self.timelineData.count) counted on page load")

    
    if (PFUser.currentUser() == nil) {
      var loginAlert:UIAlertController = UIAlertController(title: "Sign Up/Login", message: "Log in", preferredStyle: UIAlertControllerStyle.Alert)
      loginAlert.addTextFieldWithConfigurationHandler({
        textfield in
          textfield.placeholder = "User Name"
      })
      loginAlert.addTextFieldWithConfigurationHandler({
      textfield in
        textfield.placeholder = "Password"
        textfield.secureTextEntry = true
      })
      loginAlert.addAction(UIAlertAction(title: "Log in", style: UIAlertActionStyle.Default, handler: {
            alertAction in
        let textFields:NSArray = loginAlert.textFields! as NSArray
        let usernameTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
        let passwordTextField:UITextField = textFields.objectAtIndex(1) as! UITextField
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){
          (user:PFUser?, error:NSError?)-> Void in
          if user != nil {
            println("Login successful")
          } else {
            println("Login failed")
          }
        }
      }))
      loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
        alertAction in
        let textFields:NSArray = loginAlert.textFields! as NSArray
        let usernameTextField:UITextField = textFields.objectAtIndex(0) as! UITextField
        let passwordTextField:UITextField = textFields.objectAtIndex(1) as! UITextField
        
        var owner:PFUser = PFUser()
        owner.username = usernameTextField.text
        owner.password = passwordTextField.text
        
        owner.signUpInBackgroundWithBlock{
         (succeeded, error)-> Void in
          if error == nil {
            println("Sign up successful")
          } else {
            println("\(error)")
          }
        }
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){
          (user:PFUser?, error:NSError?)-> Void in
          if user != nil {
            println("Login successful")
          } else {
            println("Login failed")
          }
        }
      }))
      
      self.presentViewController(loginAlert, animated: true, completion: nil)
    }
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("\(timelineData.count)")
        return timelineData.count
    }

    @IBAction func logout(sender: AnyObject) {
      PFUser.logOut()
      var currentUser = PFUser.currentUser()
      self.viewDidAppear(true)
    }
  

  

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        let imageFile:UIImage = self.timelineData[indexPath.row] as UIImage
        
        cell.pictureView.image = imageFile as UIImage

        
//        
//        var dataFormatter:NSDateFormatter = NSDateFormatter()
//        dataFormatter.dateFormat = "dd-MM-yyyy"
//        cell.timestampLabel.text = dataFormatter.stringFromDate(imageFile.createdAt!)
        
             return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
