//
//  AHNibLoadable.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 6/1/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

protocol AHNibLoadable {}

extension AHNibLoadable where Self: UIView {
    static func loadNib(_ nibName: String? = nil) -> Self {
        let nibName = (nibName == nil) ? "\(self)" : nibName!
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: self, options: nil).first as! Self
    }
}
