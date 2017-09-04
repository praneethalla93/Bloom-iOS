//
//  BKEventStartDateCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 8/29/2017.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEventLocationCell: UITableViewCell {
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtEventLocation: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    
    @IBAction func textButtonTapped(_ sender: Any) {
        tapAction?(self)
    }

}
