//
//  AHCategoryView.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 5/29/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit


class AHCategoryView: UIView {

    fileprivate var categories: [String]
    fileprivate var childVCs: [UIViewController]
    fileprivate weak var parentVC: UIViewController!
    fileprivate var barStyle: AHCategoryNavBarStyle
    
    fileprivate(set) var navBar: AHCategoryNavBar!
    fileprivate(set) var contentView: AHCategoryContentView!
    
    init(frame: CGRect, categories: [String], childVCs: [UIViewController], parentVC: UIViewController, barStyle: AHCategoryNavBarStyle) {
        self.categories = categories
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.barStyle = barStyle
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- For setups
extension AHCategoryView {
    func setup() {
        setupNavBar()
        setupContentView()
        
        contentView.delegate = navBar
        navBar.delegate = contentView
    }
    
    func setupNavBar() {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: barStyle.height)
        navBar = AHCategoryNavBar(frame: frame, categories: categories, barStyle: barStyle)
        addSubview(navBar)
    }
    
    func setupContentView() {
        let frame = CGRect(x: 0, y: barStyle.height, width: bounds.width, height: bounds.height - barStyle.height)
        
        contentView = AHCategoryContentView(frame: frame, childVCs: childVCs, parentVC: parentVC)
        addSubview(contentView)
        
    }
}




