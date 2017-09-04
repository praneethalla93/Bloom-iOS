//
//  BKPhotoHeaderView.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKPhotoHeaderView: UIView, AHNibLoadable {
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func awakeFromNib() {
        
    }

}
