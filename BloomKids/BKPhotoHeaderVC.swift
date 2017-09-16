//
//  BKPhotoHeaderVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKPhotoHeaderVC: UIViewController {

    fileprivate lazy var photoHeaderView: BKPhotoHeaderView = BKPhotoHeaderView.loadNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoHeaderView.frame = view.bounds
        view.addSubview(photoHeaderView)
    }


}
