//
//  BKConnectVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/25/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import BTNavigationDropdownMenu
import KeychainAccess
import SVProgressHUD

class BKConnectVC: UITableViewController {
    
    fileprivate var currentkidConnections: [BKKidModel]?
    fileprivate var pendingConnections: [BKKidActivityConnection]?
    fileprivate var schoolPlace: BKPlaceModel?
    
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
            
            self.loadCurrentKidConnections()
            self.loadPendingConnections()
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
            self?.loadCurrentKidConnections()
            
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

    
}


extension BKConnectVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
            
                if let count = pendingConnections?.count {
                    return count
                }
                else {
                    return 0
                }
            
            case 2:
                if let count = currentkidConnections?.count {
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
                return handleActiveConnections(_:_:)(tableView, indexPath)
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
                sectionTitle = "Player Summary"
            }
            
        } else if section == 1 {
            
            if let pendingConnection = pendingConnections?.count {
                
                if pendingConnection > 0 {
                    sectionTitle = "Pending Response"
                }
                
            }
            
        } else if section == 2 {
            
            sectionTitle = "Schedule a playdate with your buddy"
        }
        
        return sectionTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLoadAndReload()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            let eventSchedulerVC = UIStoryboard(name: "BKConnect", bundle: nil).instantiateViewController(withIdentifier: "BKEventScheduler") as! BKEventSchedulerVC
            eventSchedulerVC.delegate = self
            eventSchedulerVC.eventReceivingKid = self.currentkidConnections![indexPath.row]
            navigationController?.pushViewController(eventSchedulerVC, animated: true)
        } else {
            print ("selected index: \(indexPath.section)")
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

    
    func showAlertForRow(section: Int, row: Int, decision: String="") {
        
        if ( section == 1 ) {
            
            if let activityConnection = self.pendingConnections?[row] {
                
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
                
                self.present( alert, animated: true, completion: nil)
            }
            
            
        }
        else if ( section == 2 ) {
        
            if let kid = currentkidConnections?[row] {
                
                let eventSchedulerVC = UIStoryboard(name: "BKConnect", bundle: nil).instantiateViewController(withIdentifier: "BKEventScheduler") as! BKEventSchedulerVC
                eventSchedulerVC.delegate = self
                eventSchedulerVC.eventReceivingKid = kid
                navigationController?.pushViewController(eventSchedulerVC, animated: true)

            }
            
        }
        
    }


}

//handle all cell creation here
extension BKConnectVC {
    
    func handlePlayerSummaryHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSummaryHeaderCellID, for: indexPath) as! BKConnectSummaryHeaderCell
        
        //cell.imagePlayerPhoto
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            let connectionCount = self.currentkidConnections?.count ?? 0
            cell.lblPlayerName.text = "\(currentKid.kidName) | \(String(describing: currentKid.age))"
            cell.lblConnectionCounts.text = "\(String(describing: connectionCount)) Connections"
        }
        
        return cell
    }
    
    func handleActiveConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
        
        if let kid = currentkidConnections?[indexPath.row] {
        
            cell.kidModel = kid
            cell.btnPlayerAction.setImage( UIImage(named: BKImageScheduleBtnIcon), for: .normal)
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

extension BKConnectVC {
    
    func handlePendingConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidDoubleActionCellID, for: indexPath) as! BKKidDoubleActionCell
        
        if self.pendingConnections != nil {
            
            cell.btnPlayerAction1.setImage(UIImage(named: "accept-btn-icon"), for: .normal)
            cell.btnPlayerAction2.setImage(UIImage(named: "decline-btn-icon"), for: .normal)
            
            if let activityConnection = self.pendingConnections?[indexPath.row] {
                
                // Assign the tap action which will be executed when the user taps the UIButton
                cell.tapAction1 = { [weak self] (cell) in
                    self?.showAlertForRow(section: 1, row: tableView.indexPath(for: cell)!.row, decision: BKConnectAcceptRespone)
                }
                
                cell.tapAction2 = { [weak self] (cell) in
                    self?.showAlertForRow( section: 1, row: tableView.indexPath(for: cell)!.row, decision: BKConnectDeclineRespone)
                }
                
                cell.lblPlayerName.text = "\(activityConnection.kidname) || \(activityConnection.id)"
                cell.lblPlayerSchoolAge.text = "\(activityConnection.school) | Age: \(activityConnection.age) | \(activityConnection.date)"
                cell.imgSportIcon1.image = #imageLiteral(resourceName: "chess-icon")
                cell.lblActionStatus.text = activityConnection.connectionStateDescription
                cell.lblActionStatus.isHidden = activityConnection.actionLabelHidden
                cell.btnPlayerAction1.isHidden = activityConnection.btn1Hidden
                cell.btnPlayerAction2.isHidden = activityConnection.btn2Hidden
            }

        }

        return cell
    }
    
    func sendConnectResponse(row: Int, acceptDecision: Bool) {
        SVProgressHUD.show()
        print ("entering sendConnectResponse")
        
        if var activityConnection = self.pendingConnections?[row], let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let todayDate = formatter.string(from: date)
            let connectResponse = BKConnectResponse(connresponderKidId: currentKid.id!, responseAcceptStatus: acceptDecision, connectionRequestorKidId: activityConnection.id, sport: activityConnection.sport!, city: activityConnection.city, kidName: activityConnection.kidname, connectionDate: todayDate)
            
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
                    
                    self.pendingConnections?[row] = activityConnection
                }
                else {
                    print ("failure sendConnectResponse")
                }
                
                self.myGroup.leave()
            }
            
            
            
        }
        
        
        
    }
    
    
}

extension BKConnectVC: BKEventSchedulerDelegate {
    
    /*
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel) {
        BKNetowrkTool.shared.myKids?.insert(kid, at: 0)
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("didAddkid")
    }
    */
    
    func scheduleEventVC(_ vc: BKEventSchedulerVC, eventReveivingKid kid: BKKidModel) {
        //TBD
        
    }
    
}


extension BKConnectVC: BKPlaceAutocompleteDelegate {
    
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC) {
        navigationController?.popViewController(animated: true)
    }
    
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel) {
        self.schoolPlace = place
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
    
}

