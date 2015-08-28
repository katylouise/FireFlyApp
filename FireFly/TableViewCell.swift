//
//  TableViewCell.swift
//  FireFly
//
//  Created by Rebecca Appleyard on 26/08/2015.
//  Copyright (c) 2015 Firefly. All rights reserved.
//

import UIKit
import Parse
import Bolts

class TableViewCell: UITableViewCell {

  
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var penguinIcon: UIImageView!
    
  
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action: Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        penguinIcon?.hidden = true
        
        super.awakeFromNib()
        // Initialization code
    }
  
    func onDoubleTap(sender:AnyObject){
        penguinIcon?.hidden = false
        penguinIcon?.alpha = 1.0
        UIView.animateWithDuration(1.0, delay:1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.penguinIcon?.alpha = 0
            }, completion:{
                (value:Bool) in
                self.penguinIcon?.hidden = true
        })
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
