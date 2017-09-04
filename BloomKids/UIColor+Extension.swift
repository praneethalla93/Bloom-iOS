//
//  UIColor+Extension.swift
//  AHLive
//
//  Created by Raj Sathyaseelan on 5/29/17.
//  Copyright © 2017 Raj Sathyaseelan. All rights reserved.
//

import UIKit

extension UIColor {
    class func random() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// return RGB components in scale of 0~255.0
    func getRGBComponents() -> (CGFloat, CGFloat, CGFloat) {
        guard let components = self.cgColor.components, components.count == 4 else {
            fatalError("Please use RGB channels to for colors")
        }

        return (components[0], components[1], components[2])
    }
    
    /// return RGB differences between two colors
    class func getRGBDelta(first: UIColor, second: UIColor) -> (CGFloat, CGFloat, CGFloat){
        let firstComponents = first.getRGBComponents()
        let secondComponents = second.getRGBComponents()
        
        let redDelta = firstComponents.0 - secondComponents.0
        let greenDelta = firstComponents.1 - secondComponents.1
        let blueDelta = firstComponents.2 - secondComponents.2
        
        return (redDelta, greenDelta, blueDelta)
    }
    
}




