//
//  BKKidCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKKidCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!

    @IBOutlet weak var sportBtn_00: UIImageView!
    @IBOutlet weak var sportBtn_01: UIImageView!
    @IBOutlet weak var sportBtn_02: UIImageView!
    @IBOutlet weak var sportBtn_10: UIImageView!
    @IBOutlet weak var sportBtn_11: UIImageView!
    @IBOutlet weak var sportBtn_12: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var actionBtn: UIImageView!
    
    
    var kidModel: BKKidModel? {
        
        didSet {
            if let kidModel = kidModel {
                self.name.text = kidModel.kidName
                self.school.text = kidModel.school
                self.age.text = kidModel.age
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
        //@TODO: code to set the status of the KidCell
        actionBtn.image = UIImage(named: "connect-icon")
    }
    
}
