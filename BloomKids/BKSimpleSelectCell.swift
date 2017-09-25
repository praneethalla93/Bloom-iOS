//
//  BKEventStartDateCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 8/29/2017.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKSimpleSelectCell: UITableViewCell {
    
    //@IBOutlet weak var schoolNameField: UITextField!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSelect: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
