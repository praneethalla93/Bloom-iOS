//
//  BKEventDatePickerCell
//  BloomKids
//
//  Created by Raj Sathyaseelan on 8/29/2017.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEventDatePickerCell: UITableViewCell {
    
    @IBOutlet weak var datePickerEventStart: UIDatePicker!
    var eventDateChanged: ((UITableViewCell) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func didDateChange(_ sender: Any) {
        eventDateChanged?(self)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
