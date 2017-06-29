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
    
    
    fileprivate var myKids: [BKKidModel]?
    fileprivate var currentkidConnections: [BKKidModel]?
    fileprivate var currentkidPendingConnections: [BKKidModel]?
    fileprivate var cuid: BKKidModel?
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SVProgressHUD.show()

        loadMyKids()
        
        //after successfull loading data
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.setupNavigationBar()
            self.tableView.reloadData()
        }
        
        loadMyCurrentKidConnections()
        let keychain = Keychain(service: BKKeychainService)
        SVProgressHUD.dismiss()
        
    }
    
    //Setup Navigation bar
    func setupNavigationBar() {
        
        //let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        var items = [AnyObject]()
        
        for  kid in myKids! {
            items.append(kid.kidName as AnyObject)
        }
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: myKids![0].kidName, items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //self.selectedCellLabel.text = items[indexPath]
        }

    }
    
    func loadMyKids() {
        
        myGroup.enter()
        
        BKNetowrkTool.shared.locationDetails { (success, kids) in
            SVProgressHUD.dismiss()
            
            if let kids = kids, success {
                
                //no sorting.
                /*
                self.myKids = kids.sorted(by: { (kid1, kid2) -> Bool in
                    let kid1ID = kid1.id ?? 0
                    let kid2ID = kid2.id ?? 0
                    return kid1ID > kid2ID
                })
                */
                
                self.myKids = kids
                self.myGroup.leave()
            }
        }

        
        print( "My kids count \(String(describing: myKids?.count))")
    }
    
    func loadMyCurrentKidConnections() {
        
        myGroup.enter()
        
        /*
        
        BKNetowrkTool.shared.getKidConnections { ( kidId: currentkid.kidid ,success, kids) in
            SVProgressHUD.dismiss()
            
            if let kids = kids, success {
                
                //no sorting.
                /*
                 self.myKids = kids.sorted(by: { (kid1, kid2) -> Bool in
                 let kid1ID = kid1.id ?? 0
                 let kid2ID = kid2.id ?? 0
                 return kid1ID > kid2ID
                 })
                 */
                
                self.myKids = kids
                self.myGroup.leave()
            }
        }
    */
        
        
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
            
                if let count = myKids?.count {
                    return count
                }
                else {
                    return 0
                }
            
            case 2:
                return 1
            default:
                return 0
                break
        }
       
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
                
            case 0:
                return handleSummaryHeader(tableView, indexPath)
            case 1:
                return handlePlayerHeader(tableView, indexPath)
            case 2:
                return handleSectionHeader(tableView, indexPath)
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
                cell.backgroundColor = UIColor.random()
                return cell
        }
            
        

    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 160.0
        }else if indexPath.section == 1{
            return 90.0
        }else if indexPath.section == 2{
            return 40.0
        }else{
            return 40.0
        }
        
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

}

//handle all cell creation here
extension BKConnectVC {
    
    func handleSummaryHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSummaryHeaderCellID, for: indexPath) as! BKConnectSummaryHeaderCell
        
        //cell.imagePlayerPhoto
        
        if let kids = self.myKids {
            
            cell.lblPlayerName.text = kids[indexPath.row].kidName
            cell.lblConnectionCounts.text = "\(kids.count) Connected | 2 Pending"
        }
        
        //photoHeaderVC.view.willMove(toSuperview: cell.contentView)
        //cell.contentView.addSubview(photoHeaderVC.view)
        //photoHeaderVC.view.frame = cell.contentView.bounds
        //photoHeaderVC.view.didMoveToSuperview()
        return cell
    }
    
    func handlePlayerHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectPlayerCellID, for: indexPath)
        //photoHeaderVC.view.willMove(toSuperview: cell.contentView)
        //cell.contentView.addSubview(photoHeaderVC.view)
        //photoHeaderVC.view.frame = cell.contentView.bounds
        //photoHeaderVC.view.didMoveToSuperview()
        return cell
    }
    
    
    func handleSectionHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKConnectSectionHeaderCellID, for: indexPath)
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
