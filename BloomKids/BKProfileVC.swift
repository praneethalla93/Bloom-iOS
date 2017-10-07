//
//  BKProfileVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/3/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKProfileVC: UITableViewController {
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var txtProfileName: UITextField!
    @IBOutlet weak var txtProfileEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPrimaryCity:UITextField!
    @IBOutlet weak var txtRelation: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //Disable edit button for now.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = nil
        loadProfile()
    }
    
    func loadProfile() {
        let myProfile = BKNetowrkTool.shared.myProfile
        self.txtProfileName.text = myProfile?.parentName
        self.txtProfileEmail.text = myProfile?.email
        self.txtPhone.text = myProfile?.phone
        self.txtPrimaryCity.text = myProfile?.city
        self.txtRelation.text = myProfile?.relation
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
            //TODO: Settings
            return 1
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if section == 0 {
            
            if BKNetowrkTool.shared.myCurrentKid != nil {
                sectionTitle = "Profile Summary"
            } else {
                sectionTitle = BKNoKidsRegistered
            }

        }

        return sectionTitle
    }
    
    //@TODO
    @IBAction func signOutButtonTapped(_ sender: Any) {
        //reset
        BKAuthTool.shared.authVC = nil
        BKAuthTool.shared.logout()
    }
    
    
}
