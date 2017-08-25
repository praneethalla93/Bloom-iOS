//
//  BKEventsVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/25/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import BTNavigationDropdownMenu
import KeychainAccess
import SVProgressHUD

class BKEventsVC: UITableViewController {
    
    
    fileprivate var upcomingEvents: [BKKidActivitySchedule]?
    fileprivate var pendingEvents: [BKKidActivitySchedule]?
    fileprivate var pastEvents: [BKKidActivitySchedule]?
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        
        let kidCellNib = UINib(nibName: "\(BKKidActionCell.self)", bundle: nil)
        self.tableView.register(kidCellNib, forCellReuseIdentifier: BKKidActionCellID)
        
        let kidDoubleActionCellNib = UINib(nibName: "\(BKKidDoubleActionCell.self)", bundle: nil)
        self.tableView.register(kidDoubleActionCellNib, forCellReuseIdentifier: BKKidDoubleActionCellID)
        initialLoadAndReload()
        
    }
    
    func initialLoadAndReload() {
        
        loadMyKids()
        
        //after successfull loading data
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            
            //var currentKid = BKNetowrkTool.shared.myCurrentKid
            
            self.loadActivityEvents()
            //self.loadPendingConnections()
            self.setupNavigationBar()
            
            //once dropdown menu is loaded with kids. Load current Kids connection
            self.myGroup.notify(queue: .main) {
                print("connection table refreshed")
                self.tableView.reloadData()
            }
            
        }
        
        SVProgressHUD.dismiss()
    }
    
    //Setup Navigation bar
    func setupNavigationBar() {
        
        //let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
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
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: title, items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //@TODO: reload
            let myKids = BKNetowrkTool.shared.myKids
            BKNetowrkTool.shared.myCurrentKid = myKids?[indexPath]
            self?.loadActivityEvents()
            
            //once dropdown menu is loaded with kids. Load current Kids connection
            self?.myGroup.notify(queue: .main) {
                print("connect table refreshed")
                self?.tableView.reloadData()
            }
            
        }
        
    }
    
    func loadMyKids() {
        myGroup.enter()
        print ("entering load my kids")
        
        BKNetowrkTool.shared.locationDetails { (success, kids) in
            SVProgressHUD.dismiss()
            
            if let myKids = kids, success {
                self.myGroup.leave()
                print ("leaving load my kids")
                print( "My kids count \(String(describing: myKids.count))")
            }
            else {
                self.myGroup.leave()
            }
            
            
        }
        
    }
    
    
    func loadActivityEvents() {
        
        print ("entering load activity connections")
        
        //if self.selectedKidName.isEmpty || selectedKidName != BKNetowrkTool.shared.myCurrentKid?.kidName {
        myGroup.enter()
        BKNetowrkTool.shared.getActivityEvents() { (success, activityEventsResult) in
            
            self.myGroup.leave()
            SVProgressHUD.dismiss()
            
            if let activityEventList = activityEventsResult, success {
                
                self.upcomingEvents = activityEventList
                print ("success loading activity events \(String(describing: self.upcomingEvents?.count))")
                print( "Activity events count \(String(describing: self.upcomingEvents?.count))")
            }
            else {
                self.upcomingEvents = nil
                print ("failure loadActivityEvents")
            }

        }
        
        //}
        
    }

    
    /*
    func loadCurrentKidConnections() {
        
        myGroup.enter()
        
        print ("entering loading current kid connections")
        
        if let kid = BKNetowrkTool.shared.myCurrentKid {
            
            BKNetowrkTool.shared.getKidConnections(kidModel: kid) { ( success, kids) in
                SVProgressHUD.dismiss()
                
                if let kids = kids, success {
                    self.currentkidConnections = kids
                    
                    print ("success loading current kid connections \(String(describing: self.currentkidConnections?.count))")
                    
                    self.myGroup.leave()
                }
                else {
                    self.myGroup.leave()
                    self.currentkidConnections = nil
                    print ("failure loading current kid connections")
                }
                
                
            }
            
        }
        
        
    }
    
    
    func loadPendingConnections() {
        
        print ("entering load activity connections")
        
        //if self.selectedKidName.isEmpty || selectedKidName != BKNetowrkTool.shared.myCurrentKid?.kidName {
        myGroup.enter()
        BKNetowrkTool.shared.getActivityConnections() { (success, activityConnectionsResult) in
            
            self.myGroup.leave()
            SVProgressHUD.dismiss()
            
            if let activityConnectList = activityConnectionsResult, success {
                
                self.pendingConnections = activityConnectList.filter {$0.connectionState == BKKidConnectionSate.requestPending.rawValue }
                print ("success loading activity connections \(String(describing: self.pendingConnections?.count))")
                print( "Activity connection count \(String(describing: self.pendingConnections?.count))")
            }
            else {
                self.pendingConnections = nil
                print ("failure loadPendingConnections")
            }
            
        }
        
        //}
        
    }
    */
    
    
}


extension BKEventsVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            
            if let count = pendingEvents?.count {
                return count
            }
            else {
                return 0
            }
            
        case 2:
            if let count = upcomingEvents?.count {
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
            return handlePlayerSummaryHeader(tableView, indexPath)
        case 1:
            return handlePendingConnections(tableView, indexPath)
        case 2:
            return handleActiveConnections(tableView, indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
            cell.backgroundColor = UIColor.random()
            return cell
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 160.0
        }else if indexPath.section == 1 {
            return 100.0
        }else if indexPath.section == 2 {
            return 100.0
        }else{
            return 40.0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        
        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                sectionTitle = "Player Schedule"
            }
            
        } else if section == 1 {

            if let pendingEventCount = pendingEvents?.count {
                
                if pendingEventCount > 0 {
                    sectionTitle = "Pending Response"
                }
                
            }
            
        } else if section == 2 {
            sectionTitle = "Active Connections"
        }

        return sectionTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLoadAndReload()
    }
    
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     // for school search
     if indexPath.section == 4 {
     let searchVC = BKPlaceAutocompleteVC()
     searchVC.delegate = self
     searchVC.placeholder = "Enter your kid's school name"
     navigationController?.pushViewController(searchVC, animated: true)
     }
     
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BKConnectPlayerCellSeque" {
            // Create a new variable to store the instance of PlayerTableViewController
            //let destinationVC = segue.destination as! BKConnectPlayerCellVC
            //@TODO temporarily commented
            //destinationVC.currentKid = BKNetowrkTool.shared.myCurrentKid
        }
    }
    
    
    func showAlertForRow(section: Int, row: Int, decision: String="") {
        
        if ( section == 1 ) {
            
            if let activitySchedule = self.pendingEvents?[row] {
                
                var acceptFlag = false
                
                if decision == BKConnectAcceptRespone {
                    acceptFlag = true
                }
                
                let alert = UIAlertController ( title: "New Connection Response",
                                                message: "Are you sure you Want to \(decision) connection reuest from \(activitySchedule.kidName)", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                    print("Sending connect request activityConnection | \(activitySchedule.id)")
                    
                    self.myGroup.enter()
                    self.sendEventResponse(row: row, acceptDecision: acceptFlag)
                    self.myGroup.notify(queue: .main) {
                        print("Refresh cells for \(activitySchedule.kidName)")
                        self.tableView.reloadData()
                    }
                    
                    //@TODO call connect requestor API
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle reject Logic here")
                    self.dismiss(animated: true, completion: nil)
                    //self.sendConnectResponse(row: row, acceptDecision: false)
                    
                }))
                
                self.present( alert, animated: true, completion: nil)
            }
            
            
        }
        else if ( section == 2 ) {
            
            if let kid = upcomingEvents?[row] {
                
                let alert = UIAlertController ( title: "BEHOLD",
                                                message: "\(kid.kidName) at row \(row) was tapped!",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.default, handler: { (test) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present( alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
}

//handle all cell creation here
extension BKEventsVC {
    
    func handlePlayerSummaryHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSummaryHeaderCellID, for: indexPath) as! BKEventsSummaryHeaderCell
        
        //cell.imagePlayerPhoto
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            let eventCount = self.upcomingEvents?.count ?? 0
            cell.lblPlayerName.text = "\(currentKid.kidName) | \(String(describing: currentKid.age))"
            cell.lblConnectionCounts.text = "\(String(describing: eventCount)) Connections"
        }
        
        return cell
    }
    
    
    func handleActiveConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
        
        if let kid = self.upcomingEvents?[indexPath.row] {
            
            
            cell.lblPlayerName.text = kid.kidName
            cell.lblPlayerSchoolAge.text = "\(kid.school) , \(kid.age)"
            
            //cell.imgActionButtonImage.image = UIImage(named: BKIma)
            //cell.btnPlayerAction.setImage( UIImage(named: BKImageScheduleBtnIcon), for: .normal)
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction = { [weak self] (cell) in
                self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
            }
            
        }
        //photoHeaderVC.view.willMove(toSuperview: cell.contentView)
        //cell.contentView.addSubview(photoHeaderVC.view)
        //photoHeaderVC.view.frame = cell.contentView.bounds
        //photoHeaderVC.view.didMoveToSuperview()
        return cell
    }
    
    
    /*
     func handleName(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath) as! BKSimpleCell
     
     cell.label.text = "name"
     cell.textField.placeholder = ""
     
     cell.didChangeText = {[weak self] (text) in
     self?.name = text
     }
     
     return cell
     }
     */
    
}

extension BKEventsVC {
    
    func handlePendingConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidDoubleActionCellID, for: indexPath) as! BKKidDoubleActionCell
        
        if self.upcomingEvents != nil {
            
            cell.btnPlayerAction1.setImage(UIImage(named: "accept-btn-icon"), for: .normal)
            cell.btnPlayerAction2.setImage(UIImage(named: "decline-btn-icon"), for: .normal)
            
            if let activitySchedule = self.pendingEvents?[indexPath.row] {
                
                // Assign the tap action which will be executed when the user taps the UIButton
                cell.tapAction1 = { [weak self] (cell) in
                    self?.showAlertForRow(section: 1, row: tableView.indexPath(for: cell)!.row, decision: BKConnectAcceptRespone)
                }
                
                cell.tapAction2 = { [weak self] (cell) in
                    self?.showAlertForRow( section: 1, row: tableView.indexPath(for: cell)!.row, decision: BKConnectDeclineRespone)
                }
                
                
                cell.lblPlayerName.text = "\(activitySchedule.kidName) || \(activitySchedule.id)"
                cell.lblPlayerSchoolAge.text = "\(activitySchedule.school) | Age: \(activitySchedule.age) | \(activitySchedule.dateSchedule)"
                cell.imgSportIcon1.image = #imageLiteral(resourceName: "chess-icon")
                cell.lblActionStatus.text = activitySchedule.connectionStateDescription
                cell.lblActionStatus.isHidden = activitySchedule.actionLabelHidden
                cell.btnPlayerAction1.isHidden = activitySchedule.btn1Hidden
                cell.btnPlayerAction2.isHidden = activitySchedule.btn2Hidden
            }
            
        }
        
        return cell
    }
    
    func sendEventResponse(row: Int, acceptDecision: Bool) {
        SVProgressHUD.show()
        print ("entering sendConnectResponse")
        
        if var activitySchedule = self.pendingEvents?[row], let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let todayDate = formatter.string(from: date)
            
            let eventResponse = BKScheduleResponse(responderKidId: currentKid.id!, responderKidName: currentKid.kidName, requesterKidId: activitySchedule.id, acceptanceStatus: acceptDecision, requesterSkillLevel: 5, sportName: activitySchedule.sportName, location: activitySchedule.location, date: activitySchedule.dateSchedule, time: activitySchedule.timeSchedule)
            
            BKNetowrkTool.shared.scheduleResponder( scheduleResponse: eventResponse) { (success) in
                
                SVProgressHUD.dismiss()
                
                if success {    
                    print ("success sendConnectResponse)")
                    activitySchedule.connectionState = BKKidConnectionSate.connected.rawValue
                    
                    if acceptDecision {
                        activitySchedule.connectionState = BKKidConnectionSate.connected.rawValue
                    } else {
                        activitySchedule.connectionState = BKKidConnectionSate.rejected.rawValue
                    }
                    
                    self.pendingEvents?[row] = activitySchedule
                }
                else {
                    print ("failure sendConnectResponse")
                }
                
                self.myGroup.leave()
            }
            
            
            
        }
        
        
        
    }
    
    
}

