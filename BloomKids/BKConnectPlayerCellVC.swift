//
//  BKConnectPlayerCellVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//


import UIKit
import Foundation
import KeychainAccess
import SVProgressHUD


class BKConnectPlayerCellVC: UITableViewController {
        
        
    fileprivate var myKidsPotentialConnections: [BKKidModel]?
    var currentKid: BKKidModel?
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        
        let kidCellNib = UINib(nibName: "\(BKKidActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidActionCellID)
        
        loadMyKidsPotentialConnections(sportNameParam: "", interestLevelParam: "")
        
        //after successfull loading data
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.currentKid = self.myKidsPotentialConnections?[0]
            self.tableView.reloadData()
            
        }
        
        //let keychain = Keychain(service: BKKeychainService)
        SVProgressHUD.dismiss()
    }
    

    func loadMyKidsPotentialConnections(sportNameParam: String, interestLevelParam: String) {
        
        myGroup.enter()
        
        print ("entering loading current kid connections")
        
        if let kid = currentKid {
            
            BKNetowrkTool.shared.getKidsFiltered(kidModel: kid, sportName: sportNameParam, interestLevel: interestLevelParam) { ( success, kids) in
                SVProgressHUD.dismiss()
                
                if let kids = kids, success {
                    
                    self.myKidsPotentialConnections = kids
                    print ("success loading current kid connections \(String(describing: self.myKidsPotentialConnections?.count))")
                    
                    self.myGroup.leave()
                }
                else {
                    self.myGroup.leave()
                    print ("failure loading current kid connections")
                }
                
                
            }
            
        }
        
    }

    
    
}


extension BKConnectPlayerCellVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
   
            if let count = myKidsPotentialConnections?.count {
                return count
            }
            else {
                return 0
            }
            
        default:
            return 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            return handlePotentialConnections(_:_:)(tableView, indexPath)
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
            cell.backgroundColor = UIColor.random()
            return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100.0
        }else{
            return 40.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        
        if section == 0 {
            
            if self.currentKid != nil {
                sectionTitle = "Connect with these Bloom kids"
            }
            
        }
        
        return sectionTitle
    }
    
    
    func showAlertForRow(row: Int) {
        
        if let kid = self.myKidsPotentialConnections?[row] {
            
            let alert = UIAlertController ( title: "BEHOLD",
                                            message: "\(kid.kidName) at row \(row) was tapped!",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.default, handler: { (test) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present( alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
}

//handle all cell creation here
extension BKConnectPlayerCellVC {
    
  
    func handlePotentialConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
        
        if let kid = myKidsPotentialConnections?[indexPath.row] {
            //cell.imgPlayer = UIImage("")
            cell.lblPlayerName.text = kid.kidName
            cell.lblPlayerSchoolAge.text = "\(kid.school) , \(kid.age)"
            
            
            cell.btnPlayerAction.setImage( UIImage(named: BKImageConnectBtnIcon), for: .normal)
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction = { [weak self] (cell) in
                self?.showAlertForRow(row: tableView.indexPath(for: cell)!.row)
            }
        }
        
        return cell
    }
        
    
}

    


