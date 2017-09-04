//
//  BKEventSportSelectVC
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit


protocol BKEventSportSelectDelegate: class {
    func sportDidCancel(_ vc: BKEventSportSelectVC)
    func sportSelect(_ vc: BKEventSportSelectVC, didChooseSport sportName: String?)
}


class BKEventSportSelectVC: UITableViewController {
    weak var delegate: BKEventSportSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Sport"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: BKEventSportSelectCellID)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BKBloomSports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKEventSportSelectCellID, for: indexPath)
        cell.textLabel?.text = BKBloomSports[indexPath.row]
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
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        delegate?.sportSelect(self, didChooseSport: cell.textLabel?.text)
    }
    
}



