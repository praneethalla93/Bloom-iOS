//
//  BKConnectSummaryHeaderVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/26/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//


//
//  BKPhotoHeaderVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKConnectSummaryHeaderVC: UIViewController {
    
    fileprivate lazy var photoHeaderView: BKPhotoHeaderView = BKPhotoHeaderView.loadNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //@TODO: confirm
        photoHeaderView.frame = view.bounds
        view.addSubview(photoHeaderView)
        
    }
    
    
}
