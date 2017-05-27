//
//  BKActivityVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/21/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import MapKit
import KeychainAccess

class BKActivityVC: UITableViewController {

    @IBAction func logout(_ sender: UIBarButtonItem) {
        BKAuthTool.shared.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }

    func setupTitle() {
        let keychain = Keychain(service: BKKeychainService)
        guard let currentCity = try? keychain.getString(BKCurrentCity) else {return}
        guard let currentSate = try? keychain.getString(BKCurrentState) else {return}
        
        if let currentCity = currentCity, let currentSate = currentSate {
            navigationItem.title = "\(currentCity), \(currentSate)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
