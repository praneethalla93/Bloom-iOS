//
//  BKPlaceSearchNavVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKPlaceSearchNavVC: BKNavigationVC {
    var searchVC: BKPlaceAutocompleteVC!
    var placeholder: String = "Where is your home city?"
    var resultType: BKPlaceResultType = .city
    
    weak var placeDelegate: BKPlaceAutocompleteDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchVC = BKPlaceAutocompleteVC()
        searchVC.delegate = placeDelegate
        searchVC.resultType = resultType
        searchVC.placeholder = placeholder
        
        self.pushViewController(searchVC, animated: false)
        // Do any additional setup after loading the view.
    }


}
