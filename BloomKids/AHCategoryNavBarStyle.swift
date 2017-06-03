//
//  AHCategoryNavBarStyle.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 5/31/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

struct AHCategoryNavBarStyle {
    var height: CGFloat = 35.0
    
    /// if set to true, all items will have equal spacing.
    var isScrollabel = false
    var fontSize: CGFloat = 15.0
    var selectedFontSize: CGFloat = 17.0
    var normalColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    var selectedColor = UIColor(red: 111.4/255.0, green: 202.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    /// works only when isScrollabel is true
    var interItemSpace: CGFloat = 20.0
    
    var showIndicator = true
    var indicatorHeight:CGFloat = 3.0
    var indicatorColor:UIColor = UIColor(red: 111.4/255.0, green: 202.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    /// Position the navBar on top or bottom
    var positionOnTop = true
    
}
