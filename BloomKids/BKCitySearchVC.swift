//
//  BKCitySearch.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class BKCitySearchVC: UIViewController {
    var resultSearchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchVC()
    }
    
    func setupSearchVC() {
        let storyboard = UIStoryboard(name: "BKCitySearch", bundle: nil)
        let citySearchDisplayVC = storyboard.instantiateViewController(withIdentifier: "BKCitySearchDisplayVC") as! BKCitySearchDisplayVC
        citySearchDisplayVC.delegate = self
        
        resultSearchController = UISearchController(searchResultsController: citySearchDisplayVC)
        resultSearchController?.searchResultsUpdater = citySearchDisplayVC
        
        setupSearchBar()
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultSearchController?.isActive = true
        resultSearchController?.searchBar.becomeFirstResponder()
    }
    
    func setupSearchBar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where is your home city?"
        navigationItem.titleView = resultSearchController?.searchBar
    }

}

extension BKCitySearchVC: BKCitySearchDisplayVCDelegate {
    func citySearchDisplayVC(vc: BKCitySearchDisplayVC, didChoose city: String, state: String) {
        print("city:\(city) state:\(state)")
        let keychain = Keychain(service: BKKeychainService)
        keychain[BKCurrentCity] = city
        keychain[BKCurrentState] = state
        BKAuthTool.shared.switchToMainUI()
    }
}






