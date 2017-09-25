//
//  BKListSelectVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

protocol BKListSelectVCDelegate: class {
    func selectedChoice(_ vc: BKListSelectVC, selected: String)
}

class BKListSelectVC: UITableViewController {
    weak var delegate: BKListSelectVCDelegate?
    
    var listChoices: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if let listCount = listChoices?.count {
            count = listCount
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let displayText = listChoices?[indexPath.row]
        cell.textLabel?.text = displayText
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Choose an option"
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        delegate?.selectedChoice(self, selected: (cell?.textLabel?.text)!)
    }

}

