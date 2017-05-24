//
//  BKCitySearchDisplayVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import GooglePlaces

private let cellID = "BKCityCell"

class BKCitySearchDisplayVC: UITableViewController {
    var cities = [NSAttributedString]()
    
    var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BKCityCell
        
        cell.attributedCityNameStr = cities[indexPath.row]
        return cell
    }
 

}




extension BKCitySearchDisplayVC: UISearchResultsUpdating {
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
        filter.type = .city
        filter.country = "US"
        let placesClient = GMSPlacesClient.shared()
        placesClient.autocompleteQuery(keywords, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.cities.removeAll()
            if let results = results {
                results.forEach({ (result) in
                    let attributedCity = self.makeAttributedCityName(attributedStr: result.attributedFullText)
                    self.cities.append(attributedCity)
                    self.cityNamesDidUpdate()
                })
            }
        })
    }
    
    func makeAttributedCityName(attributedStr: NSAttributedString) -> NSAttributedString {
        let regularFont = UIFont.systemFont(ofSize: 17.0)
        let boldFont = UIFont.boldSystemFont(ofSize: 17.0)
        let attributedStr = attributedStr.mutableCopy() as! NSMutableAttributedString
        attributedStr.enumerateAttribute(kGMSAutocompleteMatchAttribute, in: NSRange.init(location: 0, length: attributedStr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) in
            let font = (value == nil) ? regularFont : boldFont
            attributedStr.addAttribute(NSFontAttributeName, value: font, range: range)
        }
        return attributedStr
    }
    
    func cityNamesDidUpdate() {
        tableView.reloadData()
    }
}
