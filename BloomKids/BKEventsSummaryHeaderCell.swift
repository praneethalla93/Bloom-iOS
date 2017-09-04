//
//  BKConnectSummaryHeaderCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEventsSummaryHeaderCell : UITableViewCell {
    //@IBOutlet weak var schoolNameField: UITextField!
    
    @IBOutlet weak var imagePlayerPhoto: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblSchoolAge: UILabel!
    @IBOutlet weak var lblConnectionCounts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
