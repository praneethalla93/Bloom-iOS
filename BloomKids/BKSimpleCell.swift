//
//  BKSimpleCell.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKSimpleCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var didChangeText: ((_ text: String) -> Void)?
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(labelTextDidChange(_:)), for: .allEditingEvents)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BKSimpleCell: UITextFieldDelegate {
    @objc func labelTextDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        didChangeText?(text)
    }
}
