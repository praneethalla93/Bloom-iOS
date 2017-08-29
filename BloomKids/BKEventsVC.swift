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
        
    
        
        let eventDoubleActionCellNib = UINib(nibName: "\(BKEventDoubleActionCell.self)", bundle: nil)
        self.tableView.register(eventDoubleActionCellNib, forCellReuseIdentifier: BKEventDoubleActionCellID)
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
                
                let currentDateTime = Date()
                
                self.pendingEvents = activityEventList.filter{ $0.connectionState == BKEventConnectionSate.requestPending.rawValue}
                self.upcomingEvents = activityEventList.filter{ $0.convertedDate > currentDateTime && $0.connectionState == BKEventConnectionSate.accepted.rawValue}
                self.pastEvents = activityEventList.filter{ $0.convertedDate < currentDateTime }
                
                //override filter
                //self.upcomingEvents = activityEventList
                
                
                print ("success loading activity events \(String(describing: self.upcomingEvents?.count))")
                print( "Activity events count \(String(describing: self.upcomingEvents?.count))")
            }
            else {
                self.upcomingEvents = nil
                print ("failure loadActivityEvents")
            }

        }
        
    }
    
    
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
            return handleEventSummaryHeader(tableView, indexPath)
        case 1:
            return handleEvents(section: indexPath.section, tableView, indexPath)
        case 2:
            return handleEvents(section: indexPath.section, tableView, indexPath)
        case 3:
            return handleEvents(section: indexPath.section, tableView, indexPath)
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
                    sectionTitle = "Awaiting Response"
                }
                
            }
            
        } else if section == 2 {
            sectionTitle = "Upcoming Events"
        } else if section == 3 {
            sectionTitle = "Past Events"
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
    
    func handleEventSummaryHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSummaryHeaderCellID, for: indexPath) as! BKEventsSummaryHeaderCell
        
        //cell.imagePlayerPhoto
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            let upcomingEventsCount = self.upcomingEvents?.count ?? 0
            let pendingEventsCount = self.pendingEvents?.count ?? 0
            cell.lblPlayerName.text = "\(currentKid.kidName) | Age: \(String(describing: currentKid.age))"
            cell.lblSchoolAge.text = currentKid.school
            cell.lblConnectionCounts.text = "\(String(describing: pendingEventsCount)) Pending | \(String(describing: upcomingEventsCount)) Upcoming"
            
        }

        return cell
    }
    
    
    func handleEvents(section: Int, _ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        
        var events: [BKKidActivitySchedule]?
        
        switch section {
            case 1:
                events = pendingEvents
            case 2:
                events = upcomingEvents
            case 3:
                events = pastEvents
            default:
                break
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKEventDoubleActionCellID, for: indexPath) as! BKEventDoubleActionCell
        
        if let activity = events?[indexPath.row] {

            cell.activitySchedule = activity
            
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction1 = { [weak self] (cell) in
                self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
            }
            
            cell.tapAction2 = { [weak self] (cell) in
                self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
            }
            
        }

        return cell
    }
    
}

extension BKEventsVC {
    
    func handlePendingEvents(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKEventDoubleActionCellID, for: indexPath) as! BKEventDoubleActionCell
        
        if let activity = self.pendingEvents?[indexPath.row] {
            
            cell.activitySchedule = activity
            
            
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.activitySchedule?.connectionState = activity.connectionState
            
            cell.tapAction1 = { [weak self] (cell) in
                self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
            }
            
            cell.tapAction2 = { [weak self] (cell) in
                self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
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
            
            //let todayDate = formatter.string(from: date)
            
            let eventResponse = BKScheduleResponse(responderKidId: currentKid.id!, responderKidName: currentKid.kidName, requesterKidId: activitySchedule.id, acceptanceStatus: acceptDecision, requesterSkillLevel: 5, sportName: activitySchedule.sportName, location: activitySchedule.location, date: activitySchedule.date, time: activitySchedule.time)
            
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

