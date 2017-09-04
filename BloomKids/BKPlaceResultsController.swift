//
//  BKCityResultsController.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/1/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit



class BKPlaceResultsController: UITableViewController {
    var places: [BKPlaceModel]? {
        didSet {
            if let places = places, places.count > 0{
                self.tableView.reloadData()
            }
        }
    }
    
    var didSelectPlace: ( (_ placeModel: BKPlaceModel) -> Void )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nibCell = UINib(nibName: "\(BKPlaceResultCell.self)", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: BKPlaceResultCellID)
        tableView.estimatedRowHeight = 70.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKPlaceResultCellID, for: indexPath) as! BKPlaceResultCell
        
        
        let placeModel = places![indexPath.row]
        cell.placeName.text = placeModel.placeName
        cell.secondary.text = placeModel.secondary
        cell.country.text = placeModel.country
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let places = places else {
            return
        }
        guard indexPath.row < places.count else {
            return
        }
        let placeModel = places[indexPath.row]
        didSelectPlace?(placeModel)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}





