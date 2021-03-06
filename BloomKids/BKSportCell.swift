//
//  BKSportCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit


private enum BKSportButtonState: Int {
    case normal = 0
    case selected
}

class BKSportCell: UITableViewCell {
    @IBOutlet weak var basketBallBtn: AHStackButton!
    @IBOutlet weak var tenisBtn: AHStackButton!
    @IBOutlet weak var baseBallBtn: AHStackButton!
    @IBOutlet weak var chessBtn: AHStackButton!
    @IBOutlet weak var cricketBtn: AHStackButton!
    @IBOutlet weak var soccerBtn: AHStackButton!
    
    var sportName: String?
    

    fileprivate var buttons = [UIButton]()
    var totalSports: [BKSport] = [BKSport]()
    
    var myTotalSports: [BKSport]? {
        
        get {
            return self.totalSports
        }
        
        set(newSports) {
            self.totalSports = newSports!
            setButtonEditState()
        }
        
    }
    
    weak var navigationVC: UINavigationController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton(btn: basketBallBtn)
        setupButton(btn: cricketBtn)
        setupButton(btn: tenisBtn)
        setupButton(btn: baseBallBtn)
        setupButton(btn: chessBtn)
        setupButton(btn: soccerBtn)
        //set initial state of sports buttons in edit mode
        //setButtonEditState()
    }

    func setupButton(btn: UIButton) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.layer.backgroundColor = BKAlternativeColor.cgColor
        btn.backgroundColor = BKAlternativeColor
        btn.tag = BKSportButtonState.normal.rawValue
        btn.addTarget(self, action: #selector(sportBtnTapped(_:)), for: .touchUpInside)
        buttons.append(btn)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setButtonEditState() {
        
        for sport in self.totalSports {
            
            
            let kidSportName = sport.sportName
            
            for button in buttons {
                
                if (button.titleLabel?.text?.lowercased() == kidSportName.lowercased()) {
                    button.tag = BKSportButtonState.selected.rawValue
                    setSportSelected(btn: button)
                }
                
                continue
            }

        }
        
    }

}


//MARK:- Event Handling
extension BKSportCell {
    
    @objc func sportBtnTapped(_ btn: UIButton) {
        
        if btn.tag == BKSportButtonState.normal.rawValue {
            
                //here making the sport selected
                let sportLevelVC = UIStoryboard(name: "BKProfile", bundle: nil).instantiateViewController(withIdentifier: "BKSportLevelVC") as! BKSportLevelVC
                sportLevelVC.delegate = self
                self.sportName = btn.titleLabel?.text ?? "Unknown Sport"
                navigationVC?.pushViewController(sportLevelVC, animated: true)
            
        } else {
            
            //here removing it if this is already selected
            let buttonLabel = btn.titleLabel!.text?.lowercased()
            
            for i in 0..<totalSports.count {
                
                let sport = totalSports[i]
                let sportName = sport.sportName.lowercased()
                
                if sportName == buttonLabel {
                    totalSports.remove(at: i)
                    print("a sport deleted")
                    break
                }
                
            }
            
            btn.tag = BKSportButtonState.normal.rawValue
            btn.setImage(UIImage(named: "sport-add-icon"), for: .normal)
            btn.layer.borderWidth = 0.0
            btn.backgroundColor = BKAlternativeColor
            btn.setTitleColor(UIColor.white, for: .normal)
        }

    }

}

extension BKSportCell: BKSportLevelVCDelegate {
    
    func sportLevel(_ vc: BKSportLevelVC, skillLevel: String) {
        //let sportName = vc.sportName

        let btn = buttons.filter { (btn) -> Bool in
            return btn.titleLabel!.text! == self.sportName
        }.first
        if let selectedSportName = self.sportName {
            print("a sport added")
            var sportDict = [String: String]()
            sportDict["sportName"] = selectedSportName
            sportDict["skillLevel"] = skillLevel
            
            let newSport = BKSport(dict: sportDict)
            totalSports.append(newSport)
            setSportSelected(btn: btn)
            /*
            btn?.tag = BKSportButtonState.selected.rawValue
            btn?.setImage(#imageLiteral(resourceName: "sport-selected"), for: .normal)
            btn?.layer.borderWidth = 1.0
            btn?.layer.borderColor = BKAlternativeColor.cgColor
            btn?.backgroundColor = UIColor.white
            btn?.setTitleColor(BKAlternativeColor, for: .normal)
            */
        }
        
        navigationVC?.popViewController(animated: true)
    }
    
    func setSportSelected(btn: UIButton?) {
        btn?.tag = BKSportButtonState.selected.rawValue
        btn?.setImage(#imageLiteral(resourceName: "sport-selected"), for: .normal)
        btn?.layer.borderWidth = 1.0
        btn?.layer.borderColor = BKAlternativeColor.cgColor
        btn?.backgroundColor = UIColor.white
        btn?.setTitleColor(BKAlternativeColor, for: .normal)
    }

}







