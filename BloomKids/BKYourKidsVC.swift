//
//  BKYourKidsVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class BKYourKidsVC: UITableViewController {

    fileprivate var kids: [BKKidModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let kidCellNib = UINib(nibName: "\(BKKidCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidCellID)
        
        SVProgressHUD.show()
        BKNetowrkTool.shared.locationDetails { (success, kids) in
            SVProgressHUD.dismiss()
            if let kids = kids, success {
                self.kids = kids.sorted(by: { (kid1, kid2) -> Bool in
                    let kid1ID = kid1.id ?? 0
                    let kid2ID = kid2.id ?? 0
                    return kid1ID > kid2ID
                })
                self.tableView.reloadData()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return kids?.count ?? 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BKAddKidCellID, for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: BKKidCellID, for: indexPath) as! BKKidCell
            
            let kidModel = kids![indexPath.row]
            cell.kidModel = kidModel
            return cell
            
        }


    
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 35.0
        }else{
            return BKKidCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let addKidVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "BKAddKidVC") as!
            BKAddKidVC
            
            addKidVC.delegate = self
            navigationController?.pushViewController(addKidVC, animated: true)
        }
    }

}

extension BKYourKidsVC: BKAddKidVCDelegate {
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel) {
        kids?.insert(kid, at: 0)
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("didAddkid")
    }
}




