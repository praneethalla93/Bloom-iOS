//
//  BKNavigationVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        self.navigationBar.barTintColor = BKGlobalTintColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont.systemFont(ofSize: BKNavigationBarTitleFontSize)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
