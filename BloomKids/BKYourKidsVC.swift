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
    

    fileprivate var myKids: [BKKidModel]?
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let kidCellNib = UINib(nibName: "\(BKKidActionCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidActionCellID)
        /*
        let kidCellNib = UINib(nibName: "\(BKKidCell.self)", bundle: nil)
        tableView.register(kidCellNib, forCellReuseIdentifier: BKKidCellID)
        */
        
        SVProgressHUD.show()
        myGroup.enter()
        
        BKNetowrkTool.shared.getMyKids { (success, kids) in
            SVProgressHUD.dismiss()
            if let myKids = kids, success {
                self.myKids = myKids
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.myKids?.count ?? 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BKAddKidCellID, for: indexPath)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: BKKidActionCellID, for: indexPath) as! BKKidActionCell
            let kidModel = self.myKids![indexPath.row]
            cell.kidModel = kidModel
            
            //cell.imgActionButtonImage.image = UIImage(named: BKImageEditBtnIcon)
            
            cell.btnPlayerAction.setImage( UIImage(named: BKImageEditBtnIcon), for: .normal)
            // Assign the tap action which will be executed when the user taps the UIButton
            cell.tapAction = { [weak self] (cell) in
                self?.showAlertForRow(row: tableView.indexPath(for: cell)!.row)
            }
            
            return cell
        }
    
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 35.0
        }else{
            
            //@TOD: Raj changing height for testing
            //return 400 + 20
            return BKKidCellHeight
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let addKidVC = UIStoryboard(name: "BKProfile", bundle: nil).instantiateViewController(withIdentifier: "BKAddKidVC") as! BKAddKidVC
            addKidVC.delegate = self
            navigationController?.pushViewController(addKidVC, animated: true)
        }
    }
    
    func showAlertForRow(row: Int) {
        
        if let kid = self.myKids?[row] {
        
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

extension BKYourKidsVC: BKAddKidVCDelegate {
    
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel) {
        self.myKids?.insert(kid, at: 0)
        self.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        print("didAddkid")
    }
}




