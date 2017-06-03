//
//  BKAutocompleteCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/1/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKPlaceResultCell: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var secondary: UILabel!
    @IBOutlet weak var country: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
