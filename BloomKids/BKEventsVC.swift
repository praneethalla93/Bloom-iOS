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
        //SVProgressHUD.show()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = BKKidActionCellHeight
        
        let eventDoubleActionCellNib = UINib(nibName: "\(BKEventDoubleActionCell.self)", bundle: nil)
        self.tableView.register(eventDoubleActionCellNib, forCellReuseIdentifier: BKEventDoubleActionCellID)
        
        let eventDoubleActionNewCellNib = UINib(nibName: "\(BKEventDoubleActionNewCell.self)", bundle: nil)
        self.tableView.register(eventDoubleActionNewCellNib, forCellReuseIdentifier: BKEventDoubleActionNewCellID)
        //initialLoadAndReload()
    }
    
    func initialLoadAndReload() {
        loadMyKids()

        //after successfull loading data
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            
            if BKNetowrkTool.shared.myKids != nil {
                self.loadActivityEvents()
                //self.loadPendingConnections()
                self.setupNavigationBar()
                
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
            
            //once dropdown menu is loaded with kids. Load events
            self?.myGroup.notify(queue: .main) {
                print("event table refreshed")
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
 
            if let activityEventList = activityEventsResult, success {
                let currentDateTime = Date()
                //Pending events are pending the current user response
                self.pendingEvents = activityEventList.filter{ $0.connectionState == BKEventConnectionSate.requestPending.rawValue && $0.convertedDate > currentDateTime}

                if let pendingEvents = self.pendingEvents {
                    self.pendingEvents = self.sortEvents(events: pendingEvents, order: "ASC")
                }

                self.upcomingEvents = activityEventList.filter{ ($0.convertedDate > currentDateTime && ($0.connectionState == BKEventConnectionSate.accepted.rawValue ||  $0.connectionState == BKEventConnectionSate.declined.rawValue || $0.connectionState == BKEventConnectionSate.requestSent.rawValue) )
                }
                
                if let upcomingEvents = self.upcomingEvents {
                    self.upcomingEvents = self.sortEvents(events: upcomingEvents, order: "ASC")
                }
                /*
                self.upcomingEvents?.sort { (object1, object2) -> Bool in
                    
                    let dateFormatter = DateFormatter()
                    var date1 = Date()
                    var date2 = Date()
                    
                    if ( object1.date.characters.count == 8 ) {
                        dateFormatter.dateFormat = "MM/dd/yy"
                        date1 = dateFormatter.date(from: object1.date)!
                    } else if ( object1.date.characters.count == 10 ) {
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        date1 = dateFormatter.date(from: object1.date)!
                    }
                    
                    
                    if ( object2.date.characters.count == 8 ) {
                        dateFormatter.dateFormat = "MM/dd/yy"
                        date2 = dateFormatter.date(from: object2.date)!
                    } else if ( object2.date.characters.count == 10 ) {
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        date2 = dateFormatter.date(from: object2.date)!
                    }
                    
                    return (date1 < date2)
                }
                */
                //past events all status
                self.pastEvents = activityEventList.filter{ $0.convertedDate < currentDateTime }

                if let pastEvents = self.pastEvents {
                    self.pastEvents = self.sortEvents(events: pastEvents, order: "DESC")
                }

                //override filter
                //self.upcomingEvents = activityEventList
                print ("success loading upcoming events \(String(describing: self.upcomingEvents?.count))")
                print( "success loading pending events \(String(describing: self.pendingEvents?.count))")
                print( "success loading past events \(String(describing: self.pastEvents?.count))")
            }
            else {
                self.upcomingEvents = nil
                self.pastEvents = nil
                self.pendingEvents = nil
                self.tableView.reloadData()
                print ("failure loadActivityEvents")
            }
            
            self.myGroup.leave()
            SVProgressHUD.dismiss()
        }

    }
    
}


extension BKEventsVC {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func sortEvents ( events: [BKKidActivitySchedule], order: String) -> [BKKidActivitySchedule] {
        var sortedEvents: [BKKidActivitySchedule]
            
        if (order == "ASC") {
            sortedEvents = events.sorted(by: { $0.convertedDate.compare($1.convertedDate) == .orderedAscending })
        } else {
            sortedEvents = events.sorted(by: { $0.convertedDate.compare($1.convertedDate) == .orderedDescending })
        }
        /*
        events.sorted { (object1, object2) -> Bool in
            /*
            let dateFormatter = DateFormatter()
            var date1 = Date()
            var date2 = Date()
            
            if ( object1.date.characters.count == 8 ) {
                object1
                
                
                dateFormatter.dateFormat = "MM/dd/yy"
                date1 = dateFormatter.date(from: object1.date)!
            } else if ( object1.date.characters.count == 10 ) {
                dateFormatter.dateFormat = "MM/dd/yyyy"
                date1 = dateFormatter.date(from: object1.date)!
            }
            
            
            if ( object2.date.characters.count == 8 ) {
                dateFormatter.dateFormat = "MM/dd/yy"
                date2 = dateFormatter.date(from: object2.date)!
            } else if ( object2.date.characters.count == 10 ) {
                dateFormatter.dateFormat = "MM/dd/yyyy"
                date2 = dateFormatter.date(from: object2.date)!
            }
 
            //return (date1 < date2)
             */
            var orderTest = object1.convertedDate < object2.convertedDate
            
            if (order == "ASC") {
                orderTest = !orderTest
            }
            
            return orderTest
        }
        */
        return sortedEvents
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
        case 3:
            if let count = pastEvents?.count {
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
        } else if indexPath.section == 1 {
            return BKKidEventActionCellHeight
        } else if indexPath.section == 2 {
            return BKKidEventActionCellHeight
        } else if indexPath.section == 3 {
            return BKKidEventActionCellHeight
        }
        else{
            return 40.0
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""

        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                sectionTitle = "Player Schedule"
            } else {
                sectionTitle = BKNoKidsRegistered
            }
            
        } else if section == 1 {

            if let pendingEventCount = pendingEvents?.count {
                
                if pendingEventCount > 0 {
                    sectionTitle = "Pending your response"
                }

            }
            
        } else if section == 2 {
            
            if let upComingEventCount = upcomingEvents?.count {
                
                if upComingEventCount > 0 {
                    sectionTitle = "Upcoming PlayDates"
                }
   
            }
            
            
        } else if section == 3 {
            
            if let pastEventCount = pastEvents?.count {
                
                if pastEventCount > 0 {
                    sectionTitle = "Past PlayDates"
                }
                
            }
            
        }

        return sectionTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if BKNetowrkTool.shared.myCurrentKid != nil {
            initialLoadAndReload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BKConnectPlayerCellSeque" {
            // Create a new variable to store the instance of PlayerTableViewController
            //let destinationVC = segue.destination as! BKConnectPlayerCellVC
            //@TODO temporarily commented
            //destinationVC.currentKid = BKNetowrkTool.shared.myCurrentKid
        }
    }
    
    func showAlertForRow(cell: UITableViewCell, section: Int, row: Int, decision: String="") {
        
        var events: [BKKidActivitySchedule]?
        
        
        if ( section == 1 ) {
            events = pendingEvents
        } else if ( section == 2 ) {
            events = upcomingEvents
        } else {
            return
        }
            
        if let activitySchedule = events?[row] {
            
            var acceptFlag = false
            
            if decision == BKConnectAcceptRespone {
                acceptFlag = true
            }
            
            let alert = UIAlertController ( title: "New PlayDate Confirmation",
                                            message: "Are you sure you want to \(decision) playdate reuest from \(activitySchedule.kidName)", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                print("Sending connect request activityConnection | \(activitySchedule.id)")
                self.myGroup.enter()
                self.sendEventResponse(section: section, row: row, acceptDecision: acceptFlag)
                
                self.myGroup.notify(queue: .main) {

                    if (section == 1 ) {
                        events?.remove(at: row)
                        self.pendingEvents = events
                    }
                    
                    if (decision == BKConnectAcceptRespone) {
                        SVProgressHUD.showSuccess(withStatus: "Event accepted successfully.")
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "Event declined successfully.")
                    }
                    
                    print("Refresh cells for \(activitySchedule.kidName)")
                    self.tableView.reloadData()
                }

                //@TODO call connect requestor API
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle reject Logic here")
                self.dismiss(animated: true, completion: nil)
            }))

            alert.popoverPresentationController?.sourceView = cell
            alert.popoverPresentationController?.sourceRect = cell.bounds
            self.present( alert, animated: true, completion: nil)
        }
        
    }

}

//handle all cell creation here
extension BKEventsVC {
    
    func handleEventSummaryHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSummaryHeaderCellID, for: indexPath) as! BKEventsSummaryHeaderCell

        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            let upcomingEventsCount = self.upcomingEvents?.count ?? 0
            let pendingEventsCount = self.pendingEvents?.count ?? 0
            //let pastEventsCount = self.pastEvents?.count ?? 0
            
            cell.lblPlayerName.text = currentKid.kidName
            cell.lblSchoolAge.text = currentKid.school
            cell.lblConnectionCounts.text = "Play Dates: \(String(describing: pendingEventsCount)) Pending | \(String(describing: upcomingEventsCount)) Upcoming"
        } else {
            cell.lblPlayerName.text = ""
            cell.lblSchoolAge.text = ""
            cell.lblConnectionCounts.text = ""
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

        //let cell = tableView.dequeueReusableCell(withIdentifier: BKEventDoubleActionCellID, for: indexPath) as! BKEventDoubleActionCell
        let cell = tableView.dequeueReusableCell(withIdentifier: BKEventDoubleActionNewCellID, for: indexPath) as! BKEventDoubleActionNewCell
        
        if let activity = events?[indexPath.row] {
            
            //set state before setting a view
            cell.activitySchedule = activity
            
            //let connectionSate = cell.activitySchedule?.connectionState
            //cell.activitySchedule?.connectionState = (cell.activitySchedule?.connectionState)!
            //let connectionSate = cell.activitySchedule?.connectionState
            
            switch section {
                //Pending events
                case 1:
                    cell.eventStatus = "Pending"
                //Upcoming events
                case 2:
                    cell.eventStatus = "Upcoming"
                //Past events
                case 3:
                    cell.eventStatus = "Past"
                default:
                    break
            }
            
            //TODO: temorarily setting these until we have a good of tracking events.
            cell.lblActionStatus.isHidden = false
            cell.lblCreatedBy.isHidden = true
            
            if (section == 3) {
                cell.lblDisplayAction.isHidden = true
            } else {
                cell.lblDisplayAction.isHidden = false
            }
            /*
            //TODO: temporary code. clean it up.
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy H:mm a"
            let converetedDateStr = formatter.string(from: activity.convertedDate)
            cell.lblCreatedBy.text = "\(activity.date) \(activity.time) \(converetedDateStr)"
           */
            
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction1 = { [weak self] (cell) in
                self?.showAlertForRow(cell: cell, section: section, row: tableView.indexPath(for: cell)!.row, decision: BKConnectAcceptRespone)
            }

            cell.tapAction2 = { [weak self] (cell) in
                self?.showAlertForRow(cell: cell, section: section, row: tableView.indexPath(for: cell)!.row, decision: BKConnectDeclineRespone)
            }

        }
        /*
        if (section == 1 || section == 2) {
            cell.accessoryType = .disclosureIndicator
        }
        */
        return cell
    }
    
}

extension BKEventsVC {
    
    func sendEventResponse(section: Int,row: Int, acceptDecision: Bool) {
        SVProgressHUD.show()
        print ("entering sendConnectResponse")
        
        var events: [BKKidActivitySchedule]?
        
        if ( section == 1 ) {
            events = pendingEvents
        } else if ( section == 2 ) {
            events = upcomingEvents
        } else {
            return
        }
        
        if var activitySchedule = events?[row], let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            //let todayDate = formatter.string(from: date)
            let eventResponse = BKScheduleResponse(responderKidId: currentKid.id!, responderKidName: currentKid.kidName, requesterKidId: activitySchedule.id, acceptanceStatus: acceptDecision, requesterSkillLevel: 5, sportName: activitySchedule.sportName, location: activitySchedule.location, date: activitySchedule.date, time: activitySchedule.time)
            
            BKNetowrkTool.shared.scheduleResponder( scheduleResponse: eventResponse) { (success) in
                SVProgressHUD.dismiss()
                
                if success {
                    print ("success sendConnectResponse)")
                    
                    if acceptDecision {
                        activitySchedule.connectionState = BKKidConnectionSate.connected.rawValue
                        activitySchedule.eventDecisionStatus = "A"
                    } else {
                        activitySchedule.connectionState = BKKidConnectionSate.rejected.rawValue
                        activitySchedule.eventDecisionStatus = "D"
                    }
                    
                    events?[row] = activitySchedule
                }
                else {
                    print ("failure sendConnectResponse")
                }
                
                self.myGroup.leave()
            }
   
        }

    }
    
}

