//
//  BKActivityVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/21/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import BTNavigationDropdownMenu


class BKActivityNewVC: UITableViewController {

    var activityConnections: [BKKidActivityConnection]?
    let myGroup = DispatchGroup()
    var menuView: BTNavigationDropdownMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = BKKidActionCellHeight - 50

        let kidCellNib = UINib(nibName: "\(BKKidDoubleActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidDoubleActionCellID)
        //initialLoadAndReload()
        /*
        SVProgressHUD.show()
        myGroup.enter()
        loadMyKids()
        
        //after successfull loading data
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            //@TODO: complete requests
            self.setupNavigationBar()
            self.loadActivityConnections()
            
            //once dropdown menu is loaded with kids. Load current Kids connection
            self.myGroup.notify(queue: .main) {
                print("connection table refreshed")
                self.tableView.reloadData()
            }
            
        }

        //let keychain = Keychain(service: BKKeychainService)
        SVProgressHUD.dismiss()
        */
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        BKAuthTool.shared.logout()
    }
    
    func initialLoadAndReload() {
        
        SVProgressHUD.show()
        myGroup.enter()
        loadMyKids()
        
        //after successfull loading data
        myGroup.notify(queue: .main) {
            
            print("Finished all requests.")
            
            //TODO: take the user to add kid screen
            if BKNetowrkTool.shared.myKids != nil
            {
                //@TODO: complete requests
                self.setupNavigationBar()
                self.loadActivityConnections()
                
                //once dropdown menu is loaded with kids. Load current Kids connection
                self.myGroup.notify(queue: .main) {
                    print("connection table refreshed")
                    self.tableView.reloadData()
                }
            }
            
        }
        
        SVProgressHUD.dismiss()
    }
    
    //Setup Navigation bar
    func loadMyKids() {
        
        BKNetowrkTool.shared.getMyKids { (success, kids) in
            SVProgressHUD.dismiss()
            
            if let kids = kids, success {
                //@TODO after success load
                print( "kids count : \(kids.count)")
                self.myGroup.leave()
            } else {
                self.myGroup.leave()
            }

        }

    }

    //Setup Navigation bar
    func setupNavigationBar() {
        var items = [AnyObject]()
        let myKids = BKNetowrkTool.shared.myKids
        
        for  kid in myKids! {
            items.append(kid.kidName as AnyObject)
        }
        
        var title = ""
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            title = currentKid.kidName
        } else {
            title = items[0] as! String
        }
        
        self.menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: title, items: items)
        self.navigationItem.titleView = menuView
        
        self.menuView?.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //@TODO: reload
            BKNetowrkTool.shared.myCurrentKid = BKNetowrkTool.shared.myKids?[indexPath]
            self?.loadActivityConnections()
            //once dropdown menu is loaded with kids. Load current Kids connection
            self?.myGroup.notify(queue: .main) {
                print("connect table refreshed")
                self?.tableView.reloadData()
            }
        }
            
        
        
    }
    
    func loadActivityConnections() {
        
        print ("entering load activity connections")
        
        //if self.selectedKidName.isEmpty || selectedKidName != BKNetowrkTool.shared.myCurrentKid?.kidName {
        self.myGroup.enter()
        
        BKNetowrkTool.shared.getActivityConnections() { (success, activityConnectionsResult) in
                
            self.myGroup.leave()
            SVProgressHUD.dismiss()
                
            if let activityConnectList = activityConnectionsResult, success {
                self.activityConnections = activityConnectList
                print ("success loading activity connections \(String(describing: self.activityConnections?.count))")
                print( "Activity connection count \(String(describing: self.activityConnections?.count))")
            }
            else {
                self.activityConnections = nil
                print ("failure loadActivityConnections")
            }

        }

    }

}

extension BKActivityNewVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            
            if let activityConnectionList = self.activityConnections {
                return activityConnectionList.count
            } else {
                return 0
            }
            
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            return handleActivityConnection(tableView, indexPath)
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
            cell.backgroundColor = UIColor.random()
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 130
        } else {
            return 40.0
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        var sectionTitle = ""
        
        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                sectionTitle = "Connection Activity"
            } else {
                sectionTitle = BKNoKidsRegistered
            }

        }

        return sectionTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        
        if BKNetowrkTool.shared.myCurrentKid != nil {
            initialLoadAndReload()
        }
        
    }
    
    func showAlertForRow( cell: UITableViewCell, row: Int, decision: String) {
        //let myKids = BKNetowrkTool.shared.myKids
        if let activityConnection = self.activityConnections?[row] {
            
            var acceptFlag = false
            
            if decision == BKConnectAcceptRespone {
                acceptFlag = true
            }
            
            let alert = UIAlertController ( title: "New Connection Response",
                                            message: "Are you sure you Want to \(decision) connection reuest from \(activityConnection.kidname)", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                print("Sending connect request activityConnection | \(activityConnection.id)")
                
                self.myGroup.enter()
                self.sendConnectResponse(row: row, acceptDecision: acceptFlag)
                self.myGroup.notify(queue: .main) {
                    print("Refresh cells for \(activityConnection.kidname)")
                    self.tableView.reloadData()
                }

                //@TODO call connect requestor API
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle reject Logic here")
                self.dismiss(animated: true, completion: nil)
                //self.sendConnectResponse(row: row, acceptDecision: false)
                
            }))
            
            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = cell.bounds
            self.present( alert, animated: true, completion: nil)
        }

    }

}

extension BKActivityNewVC {
    
    func handleActivityConnection(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidDoubleActionCellID, for: indexPath) as! BKKidDoubleActionCell
        
        if self.activityConnections != nil {
            
            //cell.btnPlayerAction1.setImage(UIImage(named: "accept-btn-icon"), for: .normal)
            //cell.btnPlayerAction2.setImage(UIImage(named: "decline-btn-icon"), for: .normal)
            
            if let activityConnection = self.activityConnections?[indexPath.row] {
                
                // Assign the tap action which will be executed when the user taps the UIButton
                cell.tapAction1 = { [weak self] (cell) in
                    self?.showAlertForRow(cell: cell, row: tableView.indexPath(for: cell)!.row, decision: BKConnectAcceptRespone)
                }
                
                cell.tapAction2 = { [weak self] (cell) in
                    self?.showAlertForRow( cell: cell, row: tableView.indexPath(for: cell)!.row, decision: BKConnectDeclineRespone)
                }
            
                //cell.lblPlayerName.text = "\(activityConnection.kidname) || \(activityConnection.id)"
                //cell.lblPlayerName.text = activityConnection.kidname
                //cell.lblPlayerSchoolAge.text = "\(activityConnection.school) | Age: \(activityConnection.age) | \(activityConnection.date)"
                //cell.imgSportIcon1.image = #imageLiteral(resourceName: "chess-icon")
                
                cell.lblPlayerName.text = activityConnection.kidname
                cell.lblPlayerSchoolAge.text = "\(activityConnection.age), \(activityConnection.school)"
                
                if let sport = activityConnection.sport {
                    
                    if !sport.sportName.isEmpty {
                        cell.imgSportIcon1.image = BKSportImageDict[(sport.sportName)]
                    } else {
                        cell.imgSportIcon1.isHidden = true
                    }
                    
                } else {
                    cell.imgSportIcon1.isHidden = true
                }
                
                cell.imgSportIcon2.isHidden = true
                cell.imgSportIcon3.isHidden = true
                cell.imgSportIcon4.isHidden = true
                cell.imgSportIcon5.isHidden = true
                cell.imgSportIcon6.isHidden = true
                cell.lblDisplayName.isHidden = true

                cell.lblActionStatus.text = activityConnection.connectionStateDescription
                cell.lblActionStatus.isHidden = activityConnection.actionLabelHidden
                cell.btnPlayerAction1.isHidden = activityConnection.btn1Hidden
                cell.btnPlayerAction2.isHidden = activityConnection.btn2Hidden
                //cell.lblDisplayName.isHidden = activityConnection.lblDisplayHidden
            }

        }
        
        return cell
    }
    
    func sendConnectResponse(row: Int, acceptDecision: Bool) {
        SVProgressHUD.show()
        print ("entering sendConnectResponse")
        
        if var activityConnection = self.activityConnections?[row], let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let todayDate = formatter.string(from: date)
            let connectResponse = BKConnectResponse(connresponderKidId: currentKid.id!, responseAcceptStatus: acceptDecision, connectionRequestorKidId: activityConnection.id, sport: (activityConnection.sport), city: activityConnection.city, kidName: activityConnection.kidname, connectionDate: todayDate)
            
            BKNetowrkTool.shared.connectionResponder( connectResponse: connectResponse) { (success) in
                
                SVProgressHUD.dismiss()
                
                if success {
                    print ("success sendConnectResponse)")
                    activityConnection.connectionState = BKKidConnectionSate.connected.rawValue
                    
                    if acceptDecision {
                        activityConnection.connectionState = BKKidConnectionSate.connected.rawValue
                    } else {
                        activityConnection.connectionState = BKKidConnectionSate.rejected.rawValue
                    }
                    
                    self.activityConnections?[row] = activityConnection
                }
                else {
                    print ("failure sendConnectResponse")
                }
                
                self.myGroup.leave()
            }
            
        }
       
    }
    

}
