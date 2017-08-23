//
//  BKKidCellAction.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 7/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKKidActionCell: UITableViewCell {


    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    
    @IBOutlet weak var imgChessIcon: UIImageView!
    @IBOutlet weak var imgBasketballIcon: UIImageView!
    @IBOutlet weak var imgTennisIcon: UIImageView!
    @IBOutlet weak var imgBaseballIcon: UIImageView!
    @IBOutlet weak var imgSoccerIcon: UIImageView!
    @IBOutlet weak var imgCricketIcon: UIImageView!
    
    @IBOutlet weak var btnPlayerAction: UIButton!
    
    
    @IBOutlet weak var lblPlayerSchoolAge: UILabel!
    
     var tapAction: ((UITableViewCell) -> Void)?
    
    var kidModel: BKKidModel? {
        
        didSet {
            
            if let kid = kidModel {
                self.lblPlayerName.text = "\(kid.kidName) ID: \(String(describing: kid.id))"
                self.lblPlayerSchoolAge.text = "\(kid.school) , \(kid.age)"
                
                /*
                self.btnPlayerAction.setImage(UIImage(named: BKImageEditBtnIcon), for: .Normal)
                */
                
                print("Sports count : \(kid.sports.count)")
                
                self.imgChessIcon.isHidden = true
                self.imgCricketIcon.isHidden = true
                self.imgBaseballIcon.isHidden = true
                self.imgBasketballIcon.isHidden = true
                self.imgTennisIcon.isHidden = true
                self.imgSoccerIcon.isHidden = true
                
                for sport in kid.sports {
                    
                    switch sport.sportName.lowercased() {
                        
                    case "basketball":
                        self.imgBasketballIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "baseball":
                        self.imgBaseballIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "chess":
                        self.imgChessIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "cricket":
                        self.imgCricketIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "soccer":
                        self.imgSoccerIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "tennis":
                        self.imgTennisIcon.isHidden = false
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    default:
                        print("No Match: kid.kidName \(kid.kidName) \(sport.sportName)" )
                    }
                    
                }

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
    
    @IBAction func btnPlayerActionTapped(_ sender: Any) {
        tapAction?(self)
        
    }
    
    
    
    
    
}

