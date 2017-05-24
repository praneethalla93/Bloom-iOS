//
//  BKCitySearch.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKCitySearchVC: UIViewController {
    var resultSearchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchVC()
    }
    
    func setupSearchVC() {
        let storyboard = UIStoryboard(name: "BKCitySearch", bundle: nil)
        let citySearchDisplayVC = storyboard.instantiateViewController(withIdentifier: "BKCitySearchDisplayVC") as! BKCitySearchDisplayVC
        
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








