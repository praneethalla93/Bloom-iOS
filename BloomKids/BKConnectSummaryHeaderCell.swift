//
//  BKConnectSummaryHeaderswift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKConnectSummaryHeaderCell : UITableViewCell {
    //@IBOutlet weak var schoolNameField: UITextField!
    
    
    @IBOutlet weak var imagePlayerPhoto: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblConnectionCounts: UILabel!
    @IBOutlet weak var lblSchoolName: UILabel!
    @IBOutlet weak var imgSport1: UIImageView!
    @IBOutlet weak var imgSport2: UIImageView!
    @IBOutlet weak var imgSport3: UIImageView!
    @IBOutlet weak var imgSport4: UIImageView!
    @IBOutlet weak var imgSport5: UIImageView!
    @IBOutlet weak var imgSport6: UIImageView!
    
    var kidModel: BKKidModel? {
        
        didSet {
            
            imgSport1.isHidden = true
            imgSport2.isHidden = true
            imgSport3.isHidden = true
            imgSport4.isHidden = true
            imgSport5.isHidden = true
            imgSport6.isHidden = true
            
            if let kid = kidModel {
                
                for (index, sport) in kid.sports.enumerated() {
                    print( "Index \(index) || Sport \(sport.sportName) " )
                    
                    let sportName = sport.sportName.capitalized
                    
                    if index == 0 {
                        imgSport1.isHidden = false
                        imgSport1.image = BKSportImageDict[sportName]
                        continue
                    } else if index == 1 {
                        imgSport2.isHidden = false
                        imgSport2.image = BKSportImageDict[sportName]
                        continue
                    } else if index == 2 {
                        imgSport3.isHidden = false
                        imgSport3.image = BKSportImageDict[sportName]
                        continue
                    } else if index == 3 {
                        imgSport4.isHidden = false
                        imgSport4.image = BKSportImageDict[sportName]
                        continue
                    } else if index == 4 {
                        imgSport5.isHidden = false
                        imgSport5.image = BKSportImageDict[sportName]
                        continue
                    } else if index == 5 {
                        imgSport6.isHidden = false
                        imgSport6.image = BKSportImageDict[sportName]
                        continue
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
    
}
