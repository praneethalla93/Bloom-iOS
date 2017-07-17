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
    fileprivate var myKidsPotentialFilteredConnections: [BKKidModel]?
    let searchController = UISearchController(searchResultsController: nil)
    var deleteConnecionSentdKidIndexPath: IndexPath? = nil
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()
        
        let kidCellNib = UINib(nibName: "\(BKKidActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidActionCellID)
        
        loadMyKidsPotentialConnections(sportNameParam: "", interestLevelParam: "")
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = BKBloomSports
        
        searchController.searchBar.tintColor = BKGlobalTintColor
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.delegate = self as UISearchBarDelegate
        
        //after successfull loading data
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            //self.currentKid = self.myKidsPotentialConnections?[0]
            SVProgressHUD.show()
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            
        }
        
        //let keychain = Keychain(service: BKKeychainService)
        SVProgressHUD.dismiss()
    }
    

    func loadMyKidsPotentialConnections(sportNameParam: String, interestLevelParam: String) {
        
        myGroup.enter()
        SVProgressHUD.show()
        
        print ("entering loading current kid connections")
        
        if let kid = BKNetowrkTool.shared.myCurrentKid {
            
            BKNetowrkTool.shared.getKidsFiltered(kidModel: kid, sportName: sportNameParam, interestLevel: interestLevelParam) { ( success, kids) in
                SVProgressHUD.dismiss()
                
                if let kids = kids, success {
                    
                    self.myKidsPotentialConnections = kids
                    print ("success loading current kid connections \(String(describing: self.myKidsPotentialConnections?.count))")
                    self.myGroup.leave()
                }
                else {
                    self.myGroup.leave()
                    print ("failure loading potential new connections")
                }
                
            }
            
        }
    }
        
    func sendConnectRequest(receivingKid: BKKidModel) {
        
        myGroup.enter()
        SVProgressHUD.show()
        print ("entering sendConnectRequest")
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let todayDate = formatter.string(from: date)
            
            BKNetowrkTool.shared.connectionRequestor(receivingKid: receivingKid, connectorKidId: currentKid.id!, city: receivingKid.school, sportname: receivingKid.sports[0].sportName, skilllevel: receivingKid.sports[0].skillLevel, connectionDate: todayDate) { ( success) in
                
                SVProgressHUD.dismiss()
                
                if success {
                    print ("success sendConnectRequest)")
                }
                else {
                    print ("failure sendConnectRequest")
                }
                
                self.myGroup.leave()
                
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
            
            
            if searchController.isActive && searchController.searchBar.text != "" {
                
                if let filterConnections = myKidsPotentialFilteredConnections {
                    return filterConnections.count
                } else {
                    return 0
                }
                
            }
            else {
                
                if let potentialConnections = myKidsPotentialConnections {
                    return potentialConnections.count
                } else {
                    return 0
                }
                
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
        var searchCount = 0
        
        
        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                
                if searchController.isActive && searchController.searchBar.text != "" {
                    
                    if let count = myKidsPotentialFilteredConnections?.count {
                        searchCount = count
                    }
                    
                } else {
                    
                    if let count = myKidsPotentialConnections?.count {
                        searchCount = count
                    }

                    
                }
            }
            
            if searchCount == 0 {
                sectionTitle = "No kids available. Broaden your search"
                
            } else {
                sectionTitle = "\(searchCount) BloomKids available to connect."
            }

            
        }
        
        return sectionTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*
        if segue.identifier == "BKConnectPlayerCellSeque" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! BKConnectPlayerCellVC
            destinationVC.currentKid = self.currentKid
        }
        */
        
        //@TODO for connect request
        /*
        var selectedKid: BKKidModel
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            if let filteredConnections = myKidsPotentialFilteredConnections {
                selectedKid = filteredConnections[IndexPath.row]
            }
            
            
        } else {
            
            if let potentialConnections = myKidsPotentialConnections {
                selectedKid = potentialConnections[indexPath.row]
            }
            
        }
        */
    }
    
    
    
    func showAlertforSendConnection (cell: UITableViewCell) {
        
        var receivingKid: BKKidModel?
        let indexPath = self.tableView.indexPath(for: cell)!
        
        if let currentKid = BKNetowrkTool.shared.myCurrentKid {
            
            if searchController.isActive && searchController.searchBar.text != "" {
                
                if let potentialFilteredConnections = myKidsPotentialFilteredConnections {
                    receivingKid = potentialFilteredConnections[indexPath.row]
                }
                
            } else {
                
                if let potentialConnections = myKidsPotentialConnections {
                    receivingKid = potentialConnections[indexPath.row]
                }
                
            }
            
            let alert = UIAlertController ( title: "New connection request",
                                            message: "Want to connect with \(receivingKid!.kidName) at row \(indexPath.row)?",preferredStyle: .actionSheet)
            /*
            alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.default, handler: { (test) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            */
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion: nil)
                
                print("Sending connect request CurrentKid | \(String(describing: currentKid.id)) \(currentKid.kidName) | \(String(describing: receivingKid!.id)) \(receivingKid!.kidName)")
                self.sendConnectRequest(receivingKid: receivingKid!)
                self.deleteConnecionSentdKidIndexPath = indexPath
                self.handleSucessDeleteConnection(alertAction: nil)
                //@TODO call connect requestor API
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                self.cancelConnectRequest()
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present( alert, animated: true, completion: nil)
            
        }
    }
    
    func handleSucessDeleteConnection(alertAction: UIAlertAction!) -> Void {
        
        if let indexPath = deleteConnecionSentdKidIndexPath {
            
            if searchController.searchBar.text != "" {
                
                if myKidsPotentialFilteredConnections != nil {
                    //Remove from myKidsPotentialConnections as well before removing from Filter
                    
                    let kid = myKidsPotentialFilteredConnections![indexPath.row]
                    
                    var index = 0
                    
                    for forKid in myKidsPotentialConnections! {
                        
                        print ( "forKid.id \(String(describing: forKid.id )) || kid.id \(String(describing: kid.id ))")
                        
                        if forKid.id == kid.id {
                            myKidsPotentialConnections!.remove(at: index)
                            break
                        }
                        
                        index += 1
                    }
                    
                    myKidsPotentialFilteredConnections!.remove(at: indexPath.row)
                    
                }
                
            } else {
                
                if  myKidsPotentialConnections != nil {
                    myKidsPotentialConnections!.remove(at: indexPath.row)
                }

            }
            
            tableView.beginUpdates()
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteConnecionSentdKidIndexPath = nil
            tableView.endUpdates()
        }

    }
    
    func cancelConnectRequest() {
        deleteConnecionSentdKidIndexPath = nil
    }

    
    
}

//handle all cell creation here
extension BKConnectPlayerCellVC {
    
  
    func handlePotentialConnections(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
        
        var kid: BKKidModel?
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            if let filteredConnections = myKidsPotentialFilteredConnections {
                kid = filteredConnections[indexPath.row]
            }
            
        }
        else {
            
            if let potentialConnections = myKidsPotentialConnections {
                kid = potentialConnections[indexPath.row]
            }
            
        }
        
        if let currentKid = kid {
            //cell.imgPlayer = UIImage("")
            cell.kidModel = currentKid
            //cell.lblPlayerName.text = currentKid.kidName
            //cell.lblPlayerSchoolAge.text = "\(currentKid.school) , \(currentKid.age)"
            
            
            cell.btnPlayerAction.setImage( UIImage(named: BKImageConnectBtnIcon), for: .normal)
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction = { [weak self] (cell) in
                self?.showAlertforSendConnection(cell: cell)
            }
        }
        
        return cell
    }
        
    
}

extension BKConnectPlayerCellVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //filterContentForSearchText(searchController.searchBar.text!)
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
        tableView.reloadData()
    }



}

extension BKConnectPlayerCellVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        if let potentialConnections = myKidsPotentialConnections {
            
            myKidsPotentialFilteredConnections = potentialConnections.filter { kid in
                
                let kidSports = kid.sports
                var sportsMatch = false
                
                if scope == "All" {
                    sportsMatch = true
                } else {
                    
                    for kidSport in kidSports {
                        if kidSport.sportName.lowercased().contains(scope.lowercased()) {
                            sportsMatch = true
                        }
                    }
                    
                }
                
                
                if searchText.isEmpty {
                    return sportsMatch
                    
                } else {
                    
                    //let kidSearchableText = "\(kid.kidName) \(kid.school) \(kid.age) \(kid.gender)"
                    let kidSearchableText = kid.searchDescription
                    
                    //print ("Scope \(scope) || searchTech \(searchText) || kid \(kid.kidName) || sportsMarch \(sportsMatch) || Selected \(sportsMatch && kid.kidName.lowercased().contains(searchText.lowercased()))")
                    
                    print ("kidsearchabletext \(kidSearchableText) Selected \(sportsMatch && kidSearchableText.lowercased().contains(searchText.lowercased()))")
                    return  sportsMatch && kidSearchableText.lowercased().contains(searchText.lowercased())
                }
                
            }
            
            
        }
        
    }
    
    
}





