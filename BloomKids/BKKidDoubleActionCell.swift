//
//  BKKidCellAction.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 7/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKKidDoubleActionCell: UITableViewCell {


    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgSportIcon1: UIImageView!
    @IBOutlet weak var imgSportIcon2: UIImageView!
    @IBOutlet weak var imgSportIcon3: UIImageView!
    @IBOutlet weak var imgSportIcon4: UIImageView!
    @IBOutlet weak var imgSportIcon5: UIImageView!
    @IBOutlet weak var imgSportIcon6: UIImageView!
    @IBOutlet weak var btnPlayerAction1: UIButton!
    @IBOutlet weak var btnPlayerAction2: UIButton!
    @IBOutlet weak var lblPlayerSchoolAge: UILabel!
    @IBOutlet weak var lblActionStatus: UILabel!
    
    
    var tapAction1: ((UITableViewCell) -> Void)?
    var tapAction2: ((UITableViewCell) -> Void)?
    
    var kidModel: BKKidModel? {
        
        didSet {
            
            if let kid = kidModel {
                //self.lblPlayerName.text = "\(kid.kidName) ID: \(String(describing: kid.id))"
                self.lblPlayerName.text = kid.kidName
                self.lblPlayerSchoolAge.text = "\(kid.school) , \(kid.age)"
                
                /*
                self.btnPlayerAction.setImage(UIImage(named: BKImageEditBtnIcon), for: .Normal)
                */
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
    
    @IBAction func btnPlayerctionButton1Tapped(_ sender: Any) {
        tapAction1?(self)
    }
    
    @IBAction func btnPlayerctionButton2Tapped(_ sender: Any) {
        tapAction2?(self)
        
    }

    
}

