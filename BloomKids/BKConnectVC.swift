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


class BKConnectVC: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavigationBar()
        let keychain = Keychain(service: BKKeychainService)
    }
    
    //Setup Navigation bar
    func setupNavigationBar() {
        
        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Dropdown Menu", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            //self.selectedCellLabel.text = items[indexPath]
        }

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
            return 3
        case 2:
            return 1
        case 3:
            return 1
        default:
            break
        }
       
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let tableCell: UITableViewCell
            
        switch indexPath.section {
                
        case 0:
            return handleHeader(tableView, indexPath)
        case 1:
            //return handleName(tableView, indexPath)
            return tableCell
        case 2:
            //return handleGender(tableView, indexPath)
            return tableCell
        case 3:
            //return handleAge(tableView, indexPath)
            return tableCell
        default:
            break
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
        cell.backgroundColor = UIColor.random()
        return cell

    }
    
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200.0
        }else if indexPath.section == 5{
            return 200.0
        }else{
            return 50.0
        }
    }
    */

    
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
    
    func handleHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKPhotoHeaderCellID, for: indexPath)
        photoHeaderVC.view.willMove(toSuperview: cell.contentView)
        cell.contentView.addSubview(photoHeaderVC.view)
        photoHeaderVC.view.frame = cell.contentView.bounds
        photoHeaderVC.view.didMoveToSuperview()
        return cell
    }
    
    func handleName(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath) as! BKSimpleCell
        
        cell.label.text = "name"
        cell.textField.placeholder = ""
        
        cell.didChangeText = {[weak self] (text) in
            self?.name = text
        }
        
        return cell
    }
    
    
    
}
