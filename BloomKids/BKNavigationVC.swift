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
        UINavigationBar.appearance().barTintColor = BKGlobalTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont.systemFont(ofSize: BKNavigationBarTitleFontSize)]
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        navigationBar.layer.borderWidth = 0.2
        navigationBar.layer.shadowColor = BKGlobalTintColor.withAlphaComponent(0.1).cgColor
        navigationBar.layer.shadowOffset = .init(width: 1.5, height: 1.5)
        navigationBar.layer.shadowOpacity = 1.0
        navigationBar.layer.masksToBounds = false
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count >= 1 {
            let barButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(popVC(_:)))
            viewController.navigationItem.leftBarButtonItem = barButtonItem
        }
        super.pushViewController(viewController, animated: animated)
    }
    func popVC(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
}
