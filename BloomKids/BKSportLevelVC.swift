//
//  BKSportLevelVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

protocol BKSportLevelVCDelegate: class {
    func sportLevel(_ vc: BKSportLevelVC, didChooseSport sport: BKSport?)
}


class BKSportLevelVC: UITableViewController {
    weak var delegate: BKSportLevelVCDelegate?
    
    var sportName: String = "Chess"
    
    var levels: [String] = ["Rookie", "Shining", "Star", "Rock Star"]
    var interests:[String] = ["Primary", "Secondary"]
    
    fileprivate weak var currentLevelCell: BKSportLevelCell? {
        didSet {
            if let currentLevelCell = currentLevelCell {
                print("currentLevel:\(currentLevelCell.sportLabel.text)")
            }else{
                print("no current level")
            }
        }
    }
    fileprivate weak var currentInterestCell: BKSportLevelCell? {
        didSet {
            if let currentInterestCell = currentInterestCell {
                print("currentInterest:\(currentInterestCell.sportLabel.text)")
            }else{
                print("no current interest")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sportName

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let currentInterestCell = currentInterestCell,
            let currentLevelCell = currentLevelCell else {
            delegate?.sportLevel(self, didChooseSport: nil)
            return
        }
        /*
         var sportName: String
         var interestLevel: String
         var skillLevel: String
    */
        let dict = ["sportName": self.sportName, "interestLevel": currentInterestCell.sportLabel.text!, "skillLevel": currentLevelCell.sportLabel.text!]
        let sportModel = BKSport(dict: dict)
        delegate?.sportLevel(self, didChooseSport: sportModel)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return levels.count
        }else{
            return interests.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSportLevelCellID, for: indexPath) as! BKSportLevelCell
        
        var labelText: String = ""
        if indexPath.section  == 0 {
            labelText = levels[indexPath.row]
        }else{
            labelText = interests[indexPath.row]
        }
        cell.sportLabel.text = labelText
        return cell
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 0 {
            label.text = "Choose Sport Level"
        }else{
            label.text = "Choose Interest Level"
        }
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! BKSportLevelCell
        
        if indexPath.section == 0 {
            if currentLevelCell == nil {
                // no level selected yet
                currentLevelCell = cell
                return indexPath
            }else{
                // there's already one selected, deselect this one first
                currentLevelCell?.isSelected = false
                currentLevelCell = cell
                
                return indexPath
            }
        }else{
            
            if currentInterestCell == nil {
                // no interest cell selected yet
                currentInterestCell = cell
                return indexPath
            }else{
                // there's already one selected, deselect this one first
                currentInterestCell?.isSelected = false
                currentInterestCell = cell
                return indexPath
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BKSportLevelCell
        
        if indexPath.section == 0{
            if currentLevelCell == cell {
                currentLevelCell = nil
            }
        }else{
            if currentInterestCell == cell{
                currentInterestCell = nil
            }
        }
    }
    
}


//extension BKSportLevelVC {
//    func cellForLevel(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: BKSportLevelCellID, for: indexPath) as! BKSportLevelCell
//        
//        
//    }
//    
//    func cellForInterest(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: BKSportLevelCellID, for: indexPath) as! BKSportLevelCell
//        
//        
//    }
//}


