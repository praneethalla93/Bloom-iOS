//
//  AHStackButton.swift
//  AHStackButtonTest
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit

class AHStackButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup() {
        titleLabel?.textAlignment  = .center
    }

    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = self.imageView, let titleLabel = self.titleLabel, let currentImage = self.currentImage else {
            return
        }


        imageView.frame.size.width = currentImage.size.width
        imageView.frame.size.height = currentImage.size.height
        imageView.center.x = self.bounds.width * 0.5
        imageView.frame.origin.y = self.bounds.height * 0.5 - imageView.frame.size.height
        
        
        let labelHeight = self.bounds.height - imageView.frame.size.height
        let labelY = self.bounds.height * 0.5
        let labelWidth = self.bounds.width
  
        titleLabel.center.x = imageView.center.x
        titleLabel.frame.origin.y = labelY
        titleLabel.frame.size = CGSize(width: labelWidth, height: labelHeight)
        titleLabel.sizeToFit()
    }
}
