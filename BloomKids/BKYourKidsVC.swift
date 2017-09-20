//
//  BKYourKidsVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD


class BKYourKidsVC: UITableViewController {
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kidCellNib = UINib(nibName: "\(BKKidActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidActionCellID)
        
        SVProgressHUD.show()
        myGroup.enter()
        
        BKNetowrkTool.shared.getMyKids { (success, kids) in
            SVProgressHUD.dismiss()
            if success {
                self.myGroup.leave()
            }
        }

        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.tableView.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return BKNetowrkTool.shared.myKids?.count ?? 0
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: BKKidActionCell
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
            let kidModel = BKNetowrkTool.shared.myKids![indexPath.row]
            cell.kidModel = kidModel
            
            //cell.imgActionButtonImage.image = UIImage(named: BKImageEditBtnIcon)
            //cell.btnPlayerAction.setImage( UIImage(named: BKImageEditBtnIcon), for: .normal)
            cell.btnPlayerAction.setTitle("Edit Kid", for: .normal)
            
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction = { [weak self] (cell) in
                self?.showAlertForRow(row: tableView.indexPath(for: cell)!.row)
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
        }

        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*
        
        if indexPath.section == 0 {
            return BKKidCellHeight
        } else {
            //@TOD: Raj changing height for testing
            //return 400 + 20
            return BKKidCellHeight
        }
        */
        return BKKidActionCellHeight
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                sectionTitle = "Your Kids"
            } else {
                sectionTitle = BKNoKidsRegistered
            }
            
        }
        
        return sectionTitle
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.section == 1 {
            let addKidVC = UIStoryboard(name: "BKProfile", bundle: nil).instantiateViewController(withIdentifier: "BKAddKidVC") as! BKAddKidVC
            addKidVC.delegate = self
            addKidVC.mode = "EDIT"
            self.navigationController?.pushViewController(addKidVC, animated: true)
        }
        
    }
    */
    
    func showAlertForRow(row: Int) {
        
        /*
        if let kid = BKNetowrkTool.shared.myKids?[row] {
          
            let alert = UIAlertController ( title: "Edit Kid",
                message: "\(kid.kidName) at row \(row) was tapped!",
                preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Edit Kid", style: UIAlertActionStyle.default, handler: { (test) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
            self.present( alert, animated: true, completion: nil)
 
        }
        */
        self.switchToEditKidUI(row: row)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func switchToEditKidUI(row: Int) {
        let profileStoryboard = UIStoryboard(name: "BKProfile", bundle: nil)
        let editKidVC = profileStoryboard.instantiateViewController(withIdentifier: "BKAddKidVC") as! BKAddKidVC
        editKidVC.mode = "EDIT"
        editKidVC.currentEditKid = BKNetowrkTool.shared.myKids?[row]
        editKidVC.delegate = self as BKAddKidVCDelegate
        editKidVC.kidRow = row
        navigationController?.pushViewController(editKidVC, animated: true)
    }

}

extension BKYourKidsVC: BKAddKidVCDelegate {
    
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel) {
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("didAddkid")
    }
    
}
