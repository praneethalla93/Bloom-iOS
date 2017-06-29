//
//  BKTestVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/1/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKTestVC: UIViewController {

    var searchVC: BKPlaceAutocompleteVC!
    //add comment, hhg
    override func viewDidLoad() {
        super.viewDidLoad()
       //add comment, hhg
        searchVC = BKPlaceAutocompleteVC()
        searchVC.delegate = self
//        searchVC.resultType = .city
        searchVC.placeholder = "Where is your home city***?"
        navigationItem.backBarButtonItem = nil
        // Do any additional setup after loading the view.
//        navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func goSearch(_ sender: Any) {
        let vc = BKPlaceSearchNavVC()
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(searchVC, animated: true)
    }

}

extension BKTestVC: BKPlaceAutocompleteDelegate {
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC) {
        navigationController?.popViewController(animated: true)
    }
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel) {
        
    }
}
