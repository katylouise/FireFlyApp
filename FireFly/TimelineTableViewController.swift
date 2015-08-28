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
    var imagesArray = [PFFile]()
    var captionsArray = [String]()
    var timeData = [NSDate]()
    var imgObjects = [PFObject]()
    
    func loadData() {
        imagesArray.removeAll()
        captionsArray.removeAll()
        imgObjects.removeAll()
        timeData.removeAll()
        
        var query = PFQuery(className:"Images").orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                
                for object in objects! {
                    self.imagesArray.append(object["imageFile"] as! PFFile)
                    self.captionsArray.append(object["imageComment"] as! String)
                    self.timeData.append(object.createdAt as NSDate!!)
                    self.imgObjects.append(object as! PFObject)
                            
                    self.tableView.reloadData()

                }
            }

        }

    }
    

  override func viewDidAppear(animated: Bool) {
    self.loadData()
    
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
            self.viewDidAppear(true)
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
//        
//        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){
//          (user:PFUser?, error:NSError?)-> Void in
//          if user != nil {
//            println("Login successful")
//          } else {
//            println("Login failed")
//          }
//        }
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
        println("\(imagesArray.count)")
        return imagesArray.count
    }

    @IBAction func logout(sender: AnyObject) {
      PFUser.logOut()
      var currentUser = PFUser.currentUser()
      self.viewDidAppear(true)
    }
  

  

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TableViewCell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        var imageToDisplay = self.imagesArray[indexPath.row] as PFFile
        var comment = self.captionsArray[indexPath.row] as String
        var timeStamp = self.timeData[indexPath.row] as NSDate
        var singleImageObject = self.imgObjects[indexPath.row] as PFObject
        
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        cell.timestampLabel.text = dataFormatter.stringFromDate(timeStamp)
        cell.commentLabel.text = comment
        
        var imageData = imageToDisplay.getData()
        var finalImage = UIImage(data: imageData!)
        cell.pictureView.image = finalImage
        
        var findOwner:PFQuery = PFUser.query()!
        findOwner.whereKey("objectId", equalTo: singleImageObject["owner"]!.objectId!!)
        //is this line right?? TWO exclamation marks??
        
        findOwner.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error:NSError?) -> Void in
            
            if error == nil {
                let owner:PFUser = (objects! as NSArray).lastObject as! PFUser
                //add bang to objects to cast as type NSArray
                //there is actually only one obj in this array
                cell.usernameLabel.text = owner.username
            }
        }

        
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
