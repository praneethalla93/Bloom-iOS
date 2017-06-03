//
//  BKCitySearch.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

import GooglePlaces

enum BKPlaceResultType {
    case noFilter
    case city
}


protocol BKPlaceAutocompleteDelegate: class {
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel)
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC)
}



class BKPlaceAutocompleteVC: UIViewController {
    var resultType: BKPlaceResultType = .noFilter
    var placeholder: String = "Where is your home city?"
    
    // can include a keyword that appear in the results, could be the user's current city
    var includesKeyword: String?
    
    weak var delegate: BKPlaceAutocompleteDelegate?
    
    fileprivate(set) var searchResultsController: BKPlaceResultsController!
    
    
    fileprivate(set) var resultSearchController: UISearchController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsController = BKPlaceResultsController(style: .plain)
        searchResultsController.didSelectPlace = {[weak self] placeModel in
            guard self != nil else {
                return
            }
            self!.delegate?.placeAutocomplete(self!, didSelectPlace: placeModel)
        }
        
        self.view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        navigationItem.setHidesBackButton(true, animated: false)
        
        
        setupSearchVC()
    }
    
    
    func setupSearchVC() {
        
        resultSearchController = UISearchController(searchResultsController: searchResultsController)
        resultSearchController?.searchResultsUpdater = self
        
        setupSearchBar()
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        // it's IMPORTANT to set this to true when there's this VC is being pushed
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // A hack to get rid of backButton/leftButton
        let barBtn = UIBarButtonItem()
        barBtn.customView = UIView()
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // give it a break and then get it back, it works!!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) { 
            self.resultSearchController?.searchBar.becomeFirstResponder()
        }
        
    }

    
    func setupSearchBar() {
        let searchBar = resultSearchController!.searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = placeholder
        navigationItem.titleView = resultSearchController?.searchBar
    }

}


extension BKPlaceAutocompleteVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.placeAutocompleteDidCancel(self)
    }
}


extension BKPlaceAutocompleteVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let keywords = searchController.searchBar.text {
            placeAutocomplete(keywords: keywords)
        }
    }
    
    func placeAutocomplete(keywords: String) {
        guard keywords.characters.count > 0 else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let filter = GMSAutocompleteFilter()
        filter.type = (resultType == .city) ? .city : .noFilter
        filter.country = BKPlaceAutocompleteCountry
        let placesClient = GMSPlacesClient.shared()
        placesClient.autocompleteQuery(keywords, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self.processResults(results: results)
            }
        })
    }
    
    func processResults(results: [GMSAutocompletePrediction]) {
        var places = [BKPlaceModel]()
        
        for result in results {
            let placeName = result.attributedPrimaryText.string
            var secondary: String?
            var state: String?
            var country: String?
            if let secondaryText = result.attributedSecondaryText?.string{
                var components = secondaryText.components(separatedBy: ", ")
                
                if includesKeyword != nil, !components.contains(includesKeyword!) {
                    // there's a keyword to filter but this secondaryText doesn't contain it, skip!
                    continue
                }
                
                country = components.popLast()
                secondary = components.joined(separator: ", ")
                state = components.last
            }
            
            let placeModel = BKPlaceModel(placeName: placeName, secondary: secondary, state: state, country: country)
            places.append(placeModel)
        }
        
        if places.count > 0 {
            searchResultsController.places = places
        }
    }
    
}


