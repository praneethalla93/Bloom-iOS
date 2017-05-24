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
        let storyboard = UIStoryboard(name: "BKCitySearch", bundle: nil)
        let citySearchDisplayVC = storyboard.instantiateViewController(withIdentifier: "BKCitySearchDisplayVC") as! BKCitySearchDisplayVC
        
        resultSearchController = UISearchController(searchResultsController: citySearchDisplayVC)
        
        resultSearchController?.searchResultsUpdater = citySearchDisplayVC
        
        setupSearchBar()
        
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }

    func setupSearchBar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
//        searchBar.barTintColor = BKGlobalTintColor
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
    }

}








