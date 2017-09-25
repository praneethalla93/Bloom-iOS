//
//  BKConnectPlayerCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKConnectPlayerCell: UITableViewCell {
    
    //@IBOutlet weak var schoolNameField: UITextField!

    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgSportIcon1: UIImageView!
    @IBOutlet weak var imgSportIcon2: UIImageView!
    @IBOutlet weak var imgSportIcon3: UIImageView!
    @IBOutlet weak var imgSportIcon4: UIImageView!
    @IBOutlet weak var imgSportIcon5: UIImageView!
    @IBOutlet weak var imgSportIcon6: UIImageView!
    @IBOutlet weak var imgActionButtonImage: UIImageView!
    
    
    @IBOutlet weak var lblPlayerSchoolAge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
