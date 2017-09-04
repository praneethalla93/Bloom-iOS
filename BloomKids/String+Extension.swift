//
//  String+Extension.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}
