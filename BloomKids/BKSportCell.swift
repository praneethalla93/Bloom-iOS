//
//  BKSportCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit


private enum BKSportButtonState: Int {
    case normal = 0
    case selected
}

class BKSportCell: UITableViewCell {
    @IBOutlet weak var basketBallBtn: AHStackButton!
    @IBOutlet weak var footBallBtn: AHStackButton!
    @IBOutlet weak var tenisBtn: AHStackButton!
    @IBOutlet weak var baseBallBtn: AHStackButton!

    @IBOutlet weak var chessBtn: AHStackButton!
    @IBOutlet weak var soccerBtn: AHStackButton!

    fileprivate var buttons = [UIButton]()
    fileprivate(set) var totalSports: [BKSport] = [BKSport]()
    
    weak var navigationVC: UINavigationController?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton(btn: basketBallBtn)
        setupButton(btn: footBallBtn)
        setupButton(btn: tenisBtn)
        setupButton(btn: baseBallBtn)
        setupButton(btn: chessBtn)
        setupButton(btn: soccerBtn)
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

}


//MARK:- Event Handling
extension BKSportCell {
    func sportBtnTapped(_ btn: UIButton) {
        if btn.tag == BKSportButtonState.normal.rawValue {
            let sportLevelVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "BKSportLevelVC") as! BKSportLevelVC
            sportLevelVC.delegate = self
            sportLevelVC.sportName = btn.titleLabel?.text ?? "Unknown Sport"
            navigationVC?.pushViewController(sportLevelVC, animated: true)
        }else{
            for i in 0..<totalSports.count {
                let sport = totalSports[i]
                if sport.sportName == btn.titleLabel!.text {
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
    func sportLevel(_ vc: BKSportLevelVC, didChooseSport sport: BKSport?) {
        let sportName = vc.sportName
        
        let btn = buttons.filter { (btn) -> Bool in
            return btn.titleLabel!.text! == sportName
        }.first
        if let sport = sport {
            print("a sport added")
            totalSports.append(sport)
            btn?.tag = BKSportButtonState.selected.rawValue
            btn?.setImage(#imageLiteral(resourceName: "sport-selected"), for: .normal)
            btn?.layer.borderWidth = 1.0
            btn?.layer.borderColor = BKAlternativeColor.cgColor
            btn?.backgroundColor = UIColor.white
            btn?.setTitleColor(BKAlternativeColor, for: .normal)
        }
        navigationVC?.popViewController(animated: true)
    }
}







