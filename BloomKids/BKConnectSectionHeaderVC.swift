//
//  BKConnectSectionHeaderVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKConnectSectionHeaderVC: UIViewController {
    
    fileprivate lazy var photoHeaderView: BKPhotoHeaderView = BKPhotoHeaderView.loadNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //@TODO: confirm
        photoHeaderView.frame = view.bounds
        view.addSubview(photoHeaderView)
    
    }
    
    
}
