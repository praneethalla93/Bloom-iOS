//
//  BKActivityVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/21/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import BTNavigationDropdownMenu


class BKActivityNewVC: UITableViewController {

    var activityConnections: [BKKidActivityConnection]?
    
    let myGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kidCellNib = UINib(nibName: "\(BKKidDoubleActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidDoubleActionCellID)
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
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        BKAuthTool.shared.logout()
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
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: myKids![0].kidName, items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
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
        myGroup.enter()
        
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
            return 100
        } else {
            return 40.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if section == 0 {
            sectionTitle = "Connection Activity"
        }
        
        return sectionTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func showAlertForRow(activityConnection: BKKidActivityConnection, row: Int, decision: String) {
        
        let myKids = BKNetowrkTool.shared.myKids
        
        if let kid = myKids?[row] {
            
            let alert = UIAlertController ( title: "New connection request",
                                            message: "Want to connect with \(activityConnection.kidname) at row \(row)?",preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                print("Sending connect request activityConnection | \(activityConnection.id)")
                self.sendConnectResponse(activityConnection: activityConnection, acceptDecision: true)
                
                //self.handleCellUpdates(alertAction: nil)
                //@TODO call connect requestor API
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle reject Logic here")
                self.dismiss(animated: true, completion: nil)
                self.sendConnectResponse(activityConnection: activityConnection, acceptDecision: false)
                //self.cancelConnectRequest()
                
            }))
            
            self.present( alert, animated: true, completion: nil)
        }

    }

}

extension BKActivityNewVC {
    
    func handleActivityConnection(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidDoubleActionCellID, for: indexPath) as! BKKidDoubleActionCell
        
        if self.activityConnections != nil {
            
            cell.btnPlayerAction1.setImage(UIImage(named: "accept-btn-icon"), for: .normal)
            cell.btnPlayerAction2.setImage(UIImage(named: "decline-btn-icon"), for: .normal)
            
            if let activityConnection = self.activityConnections?[indexPath.row] {
                
                // Assign the tap action which will be executed when the user taps the UIButton
                cell.tapAction1 = { [weak self] (cell) in
                    self?.showAlertForRow(activityConnection: activityConnection,row: tableView.indexPath(for: cell)!.row, decision: "Accept")
                }
                
                cell.tapAction2 = { [weak self] (cell) in
                    self?.showAlertForRow(activityConnection: activityConnection, row: tableView.indexPath(for: cell)!.row, decision: "Decline")
                }
            
            
                cell.lblPlayerName.text = "\(activityConnection.kidname) || \(activityConnection.id)"
                cell.lblPlayerSchoolAge.text = "\(activityConnection.school) | Age: \(activityConnection.age) | \(activityConnection.date)"
                cell.imgSportIcon1.image = #imageLiteral(resourceName: "chess-icon")
                
                //@TODO set icons for sports based on player sport
                if ( activityConnection.connectionState == BKKidConnectionSate.requestSent.rawValue || activityConnection.connectionState == BKKidConnectionSate.requestSent.rawValue ) {
                    cell.lblActionStatus.text = "Pending"
                    cell.btnPlayerAction1.isHidden = true
                    cell.btnPlayerAction2.isHidden = true
                }
                else if (activityConnection.connectionState == BKKidConnectionSate.requestPending.rawValue ) {
                    cell.lblActionStatus.isHidden = true
 
                }
                else if (
                    activityConnection.connectionState == BKKidConnectionSate.connected.rawValue) {
                    cell.lblActionStatus.text = "Connected"
                    cell.btnPlayerAction1.isHidden = true
                    cell.btnPlayerAction2.isHidden = true
                    
                } else if (activityConnection.connectionState == BKKidConnectionSate.rejected.rawValue ) {
                    
                    //@TODO showing pending for rejected connections too
                    cell.lblActionStatus.text = "Pending"
                    cell.btnPlayerAction1.isHidden = true
                    cell.btnPlayerAction2.isHidden = true
                    
                }
                
            }
            
        }
        
        return cell
    }
    
    func sendConnectResponse(activityConnection: BKKidActivityConnection, acceptDecision: Bool) {
        
        myGroup.enter()
        SVProgressHUD.show()
        print ("entering sendConnectResponse")
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "mm/dd/yyyy"
            
            let todayDate = formatter.string(from: date)
            let connectResponse = BKConnectResponse(connresponderKidId: activityConnection.id, responseAcceptStatus: acceptDecision, connectionRequestorKidId: activityConnection.ownerId!, sport: activityConnection.sport!, city: activityConnection.city, kidName: activityConnection.kidname, connectionDate: todayDate)
            //BKNetowrkTool.shared.connectionResponder(connectResponse: <#T##BKConnectResponse#>, completion: <#T##(Bool) -> Void#>)
            
            BKNetowrkTool.shared.connectionResponder( connectResponse: connectResponse) { ( success) in
                
                SVProgressHUD.dismiss()
                
                if success {
                    print ("success sendConnectResponse)")
                }
                else {
                    print ("failure sendConnectResponse")
                }
                
                self.myGroup.leave()
                
            }
            
        }

    }
    

}
