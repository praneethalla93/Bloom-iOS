//
//  BKActivityVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/21/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import MapKit
import KeychainAccess

private let cellID = "cellID"

class BKActivityVC: UIViewController {
    let categories = ["Connections", "Events"]
    @IBAction func logout(_ sender: UIBarButtonItem) {
        BKAuthTool.shared.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        useCategoryView()
        
        let keychain = Keychain(service: BKKeychainService)
        if let _hasFinished = try? keychain.getString(BKHasFinishedTutorial), let _ = _hasFinished {
            
        }else{
            let addKidVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "BKAddKidNavVC")
            present(addKidVC, animated: true, completion: nil)
        }

    }

    
    
    func setupTitle() {
        let keychain = Keychain(service: BKKeychainService)
        guard let currentCity = try? keychain.getString(BKCurrentCity) else {return}
        guard let currentSate = try? keychain.getString(BKCurrentState) else {return}
        
        if let currentCity = currentCity, let currentSate = currentSate {
            navigationItem.title = "\(currentCity), \(currentSate)"
        }
    }
    
    func useCategoryView() {
        automaticallyAdjustsScrollViewInsets = false
        var childVCs = [UIViewController]()
        
        let connectionVC = BKConnectionVC(style: .plain)
        childVCs.append(connectionVC)
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orange
        
        childVCs.append(vc)
        
        var style = AHCategoryNavBarStyle()
        style.isScrollabel = false
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        let categoryView = AHCategoryView(frame: frame, categories: categories, childVCs: childVCs, parentVC: self, barStyle: style)
        
        view.addSubview(categoryView)
    }

}
