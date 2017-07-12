//
//  BKProfileVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKProfileVC: UITableViewController {
    @IBOutlet weak var userPhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 1
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        //call logout function
        if indexPath.section == 2 {
            BKAuthTool.shared.logout()
        }
        
        
    }
    
    //@TODO
    @IBAction func signOutButtonTapped(_ sender: Any) {
        BKAuthTool.shared.logout()
    }
    
    
    

}
