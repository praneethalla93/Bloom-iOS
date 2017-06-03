//
//  AHCategoryProtocols.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 5/31/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

//********** For NavBar
protocol AHCategoryNavBarDelegate: class {
    func categoryNavBar(_ navBar: AHCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int)
    func categoryNavBar(_ navBar: AHCategoryNavBar, didSwitchIndexTo toIndex: Int)
}

// Default implementation
extension AHCategoryNavBarDelegate{
    func categoryNavBar(_ navBar: AHCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {}
}


//********** For ContentView
protocol AHCategoryContentViewDelegate: class {
    func categoryContentView(_ contentView: UIView, didSwitchIndexTo toIndex: Int)
    
    func categoryContentView(_ contentView: UIView, transitioningFromIndex fromIndex:Int, toIndex:Int, progress: CGFloat)
    
}

// Default implementation
extension AHCategoryContentViewDelegate {
    func categoryContentView(_ contentView: AHCategoryContentView, didSwitchIndexTo toIndex: Int){}
}
