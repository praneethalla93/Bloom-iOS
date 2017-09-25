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
                //self.lblPlayerName.text = "\(kid.kidName) ID: \(String(describing: kid.id))"
                self.lblPlayerName.text = kid.kidName
                self.lblPlayerSchoolAge.text = "\(kid.grade ?? "Pre-K"), \(kid.school)"
                /*
                self.btnPlayerAction.setImage(UIImage(named: BKImageEditBtnIcon), for: .Normal)
                */
                print("Sports count : \(kid.sports.count)")
                
                self.imgChessIcon.isHidden = true
                //self.imgChessIcon.image = nil
                
                self.imgCricketIcon.isHidden = true
                //self.imgCricketIcon.image = nil
                
                self.imgBaseballIcon.isHidden = true
                //self.imgBaseballIcon.image = nil
                
                self.imgBasketballIcon.isHidden = true
                //self.imgBasketballIcon.image = nil
                
                self.imgTennisIcon.isHidden = true
                //self.imgTennisIcon.image = nil
                
                self.imgSoccerIcon.isHidden = true
                //self.imgSoccerIcon.image = nil
                
                let basketBallSportName = BKBasketballSport.lowercased()
                let baseballSportName = BKBaseballSport.lowercased()
                let chessSportName = BKChessSport.lowercased()
                let cricketSportName = BKCricketSport.lowercased()
                let soccerSportName = BKSoccerSport.lowercased()
                let tennisSportName = BKTennisSport.lowercased()
                
                for sport in kid.sports {
                    
                    switch sport.sportName.lowercased() {
                        
                    case basketBallSportName.lowercased():
                        self.imgBasketballIcon.isHidden = false
                        //self.imgBasketballIcon.image = #imageLiteral(resourceName: "basketball-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case baseballSportName:
                        self.imgBaseballIcon.isHidden = false
                        //self.imgBaseballIcon.image = #imageLiteral(resourceName: "baseball-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case chessSportName:
                        self.imgChessIcon.isHidden = false
                        //self.imgChessIcon.image = #imageLiteral(resourceName: "chess-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case cricketSportName:
                        self.imgCricketIcon.isHidden = false
                        //self.imgCricketIcon.image = #imageLiteral(resourceName: "cricket-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case soccerSportName:
                        self.imgSoccerIcon.isHidden = false
                        //self.imgSoccerIcon.image = #imageLiteral(resourceName: "soccer-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case "Football":
                        self.imgSoccerIcon.isHidden = false
                        //self.imgSoccerIcon.image = #imageLiteral(resourceName: "soccer-icon")
                        print("kid.kidName \(kid.kidName) \(sport.sportName)" )
                    case tennisSportName:
                        self.imgTennisIcon.isHidden = false
                        //self.imgTennisIcon.image = #imageLiteral(resourceName: "tennis-icon")
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
        btnPlayerAction.backgroundColor = .clear
        btnPlayerAction.layer.cornerRadius = 10
        btnPlayerAction.layer.borderWidth = 3
        btnPlayerAction.layer.borderColor = BKGlobalTintColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayerActionTapped(_ sender: Any) {
        tapAction?(self)
        
    }
    

    
    
}

