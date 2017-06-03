//
//  BKSportLevelCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKSportLevelCell: UITableViewCell {
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        checkBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkBtn.isHidden = !selected
    }

}
