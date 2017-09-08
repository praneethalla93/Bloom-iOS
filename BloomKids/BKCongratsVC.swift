//
//  BKConnectionVCTableViewController.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

private let headerCellId = "headerCellId"

class BKCongratsVC: UITableViewController {
    
    fileprivate var kids: [BKKidModel]?
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kidCellNib = UINib(nibName: "\(BKKidCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidCellID)
        tableView.contentInset.bottom = 49
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: headerCellId)

        SVProgressHUD.show()
        
        BKNetowrkTool.shared.locationDetails() { (success, kids) in
            
            SVProgressHUD.dismiss()
            if let kids = kids, success {
                self.kids = kids
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath)
            
            let numberOfKids = self.kids?.count ?? 0
            if numberOfKids > 0 {
                let headerLabel = UILabel()
                headerLabel.frame = CGRect(x: 16, y: 0, width: cell.contentView.bounds.size.width, height: cell.contentView.bounds.size.height)
                
                headerLabel.text = "Congrats! \(numberOfKids) Bloom kids in your city"
                cell.contentView.addSubview(headerLabel)
            }
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BKKidCellID, for: indexPath) as! BKKidCell
            let kidModel = kids![indexPath.row]
            cell.kidModel = kidModel
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 35.0
        } else {
            return BKKidCellHeight
        }
        
    }
    
    
    
    @IBAction func nextBtnTapped(_ sender: UIBarButtonItem) {
        //switchToAddKidUI()
        BKAuthTool.shared.switchToMainUI()
    }
    
    func switchToAddKidUI() {
        let profileStoryboard = UIStoryboard(name: "BKProfile", bundle: nil)
        let addKidVC = profileStoryboard.instantiateViewController(withIdentifier: "BKAddKidVC") as! BKAddKidVC
        addKidVC.mode = "ONBOARD"
        addKidVC.delegate = self as BKAddKidVCDelegate
        navigationController?.pushViewController(addKidVC, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BKCongratsVC: BKAddKidVCDelegate {
    
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel) {
        //self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("didAddkid")
    }
    
}

