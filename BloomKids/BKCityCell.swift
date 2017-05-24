//
//  BKCityCell.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKCityCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel! 
    var attributedCityNameStr: NSAttributedString? {
        didSet {
            if let attributedCityNameStr = attributedCityNameStr {
                cityName.attributedText = attributedCityNameStr
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
