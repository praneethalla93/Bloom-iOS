//
//  BKCitySearchDisplayVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/24/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import GooglePlaces

class BKCitySearchDisplayVC: UITableViewController {

    var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRect(x: 0, y: 64, width: 200, height: 20)
        label.backgroundColor = UIColor.orange
        self.view.addSubview(label)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        let placesClient = GMSPlacesClient.shared()
        placesClient.autocompleteQuery(keywords, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                let result = results.first
                print("Result \(result!.attributedFullText)")
                self.makeLabel(attributedStr: result!.attributedFullText)
            }
        })
    }
    
    func makeLabel(attributedStr: NSAttributedString) {
        let regularFont = UIFont.systemFont(ofSize: 17.0)
        let boldFont = UIFont.boldSystemFont(ofSize: 17.0)
        let attributedStr = attributedStr.mutableCopy() as! NSMutableAttributedString
        attributedStr.enumerateAttribute(kGMSAutocompleteMatchAttribute, in: NSRange.init(location: 0, length: attributedStr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, stop) in
            let font = (value == nil) ? regularFont : boldFont
            attributedStr.addAttribute(NSFontAttributeName, value: font, range: range)
        }
        label.attributedText = attributedStr
    }
}
