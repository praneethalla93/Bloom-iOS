//
//  BKSportLevelVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

protocol BKSportLevelVCDelegate: class {
    func sportLevel(_ vc: BKSportLevelVC, skillLevel: String)
}


class BKSportLevelVC: UITableViewController {
    weak var delegate: BKSportLevelVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Experience"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BKSportLevels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSportLevelCellID, for: indexPath) as! BKSportLevelCell
        cell.sportLabel.text = BKSportLevels[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Choose Sport Level"
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BKSportLevelCell else {return}
        delegate?.sportLevel(self, skillLevel: cell.sportLabel.text!)
    }

}

