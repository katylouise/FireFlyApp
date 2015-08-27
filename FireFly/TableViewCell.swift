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

    @IBOutlet weak var pictureView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
