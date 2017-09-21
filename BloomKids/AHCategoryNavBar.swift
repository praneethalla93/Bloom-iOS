//
//  AHCategoryNavBar.swift
//  AHCategoryVC
//
//  Created by Raj Sathyaseelan on 5/29/17.
//  Copyright © 2017 Raj Sathyaseelan. All rights reserved.
//

import UIKit


class AHCategoryNavBar: UIView {
    weak var delegate: AHCategoryNavBarDelegate?
    
    fileprivate var barStyle: AHCategoryNavBarStyle
    
    fileprivate var categories: [String]
    
    fileprivate lazy var labels = [UILabel]()
    
    fileprivate lazy var scrollView: UIScrollView = UIScrollView(frame: self.bounds)
    
    fileprivate var currentLabelTag: Int = 0
    
    fileprivate lazy var labelHeight: CGFloat = self.bounds.height
    
    fileprivate lazy var labelFont: UIFont = UIFont.systemFont(ofSize: self.barStyle.fontSize)
    
    fileprivate lazy var labelSelectedFont: UIFont = UIFont.systemFont(ofSize: self.barStyle.selectedFontSize)
    
    fileprivate lazy var indicator: UIView = {
        let view = UIView()
        view.frame.size.height = self.barStyle.indicatorHeight
        view.frame.origin.y = self.bounds.height - self.barStyle.indicatorHeight
        view.backgroundColor = self.barStyle.indicatorColor
        self.scrollView.addSubview(view)
        return view
    }()
    
    init(frame: CGRect, categories: [String], barStyle: AHCategoryNavBarStyle) {
        self.categories = categories
        self.barStyle = barStyle
        
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- Setups
extension AHCategoryNavBar {
    func setupUI() {
        setupScrollView()
        addLabels()
        
        let contentWidth:CGFloat = labels.last!.frame.maxX + barStyle.interItemSpace * 0.5
        let contentHeight:CGFloat = self.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    func setupScrollView(){
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    
    func addLabels() {
        for i in 0..<categories.count {
            let label = UILabel()
            label.text = categories[i]
            label.textColor = (i == 0) ? barStyle.selectedColor : barStyle.normalColor
            label.tag = i
            
            label.font = labelFont

            var x: CGFloat = 0.0
            let y: CGFloat = 0.0
            var width: CGFloat = 0.0
            let height = self.labelHeight
            let textWidth: CGFloat = getTextWidth(for: label)
        
            
            if barStyle.isScrollabel {
                // scrollabel, each label has its own width according to its text
                width = textWidth
                if i > 0 {
                    let previousLabel = labels[i - 1]
                    x = previousLabel.frame.maxX + barStyle.interItemSpace
                }
            }else{
                // not scrollabel, then divide width equally for all labels
                width = self.bounds.width / CGFloat(categories.count)
                label.textAlignment = .center
                
                if i > 0 {
                    x = width * CGFloat(i)
                }
            }
            
            // special treatment for the first label
            if i == 0 {
                x = barStyle.interItemSpace * 0.5
            }
            
            
            
            label.frame = CGRect(x: x, y: y, width: width, height: height)
            labels.append(label)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
            
            scrollView.addSubview(label)
            
            
            if i == 0 {
                indicator.frame.size.width = textWidth
                indicator.center.x = label.center.x
            }
            
        }
    }
    
    func getTextWidth(for label: UILabel) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: barStyle.fontSize)
        let height: CGFloat = self.bounds.height // certain
        let boundSize = CGSize(width: CGFloat(Float.greatestFiniteMagnitude), height: height)
        let textWidth = (label.text! as NSString).boundingRect(with: boundSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).width
        
        return textWidth
    }
    
}


//MARK:- Event Handling
extension AHCategoryNavBar {
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let currentLabel = gesture.view as? UILabel else {
            return
        }
        
        guard currentLabel.tag != currentLabelTag else {
            return
        }
        delegate?.categoryNavBar(self, willSwitchIndexFrom: currentLabelTag, to: currentLabel.tag)
        
        
        handleLabelSwitching(currentLabel: currentLabel)
        handleIndicator(currentLabel: currentLabel)
        
        delegate?.categoryNavBar(self, didSwitchIndexTo: currentLabel.tag)
    }
    
    func handleLabelSwitching(currentLabel: UILabel) {
        
        let previousLabel = labels[currentLabelTag]
        
        previousLabel.textColor = barStyle.normalColor
        currentLabel.textColor = barStyle.selectedColor
        currentLabelTag = currentLabel.tag
        
        scrollToCenter(currentLabel: currentLabel)
        
    }
    
    func handleIndicator(currentLabel: UILabel) {
        guard barStyle.showIndicator else {
            return
        }
        
        let textWidth = getTextWidth(for: currentLabel)
        UIView.animate(withDuration: 0.25) {
            self.indicator.frame.size.width = textWidth
            self.indicator.center.x = currentLabel.center.x
        }
    }
    
    func scrollToCenter(currentLabel: UILabel) {
        guard barStyle.isScrollabel else {
            return
        }
        
        var centerX = currentLabel.center.x - scrollView.bounds.width * 0.5
        if centerX < 0.0 {
            // for labels positioned on the left side of scrollView.bounds.width * 0.5
            centerX = 0.0
            
        }
        
        // the x position for the last screen of the scroll
        let maxLeftEdge = scrollView.contentSize.width - bounds.width
        if centerX > maxLeftEdge{
            centerX = maxLeftEdge
        }
        
        scrollView.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: true)
        
        guard barStyle.showIndicator else {
            return
        }
        
        let textWidth = getTextWidth(for: currentLabel)
        UIView.animate(withDuration: 0.25) {
            self.indicator.frame.size.width = textWidth
            self.indicator.center.x = centerX
        }
        
    }
}


extension AHCategoryNavBar: AHCategoryContentViewDelegate {
    func categoryContentView(_ contentView: UIView, didSwitchIndexTo toIndex: Int) {
        guard toIndex < labels.count else {
            return
        }
        
        let currentLabel = labels[toIndex]
        handleLabelSwitching(currentLabel: currentLabel)
        handleIndicator(currentLabel: currentLabel)
    }

    func categoryContentView(_ contentView: UIView, transitioningFromIndex fromIndex: Int, toIndex: Int, progress: CGFloat) {
        guard fromIndex >= 0, fromIndex < labels.count else {
            return
        }
        guard toIndex >= 0, toIndex < labels.count else {
            return
        }
        
        makeColorTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
        makeIndicatorTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
    func makeIndicatorTransition(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        guard barStyle.showIndicator else {
            return
        }
        
        let fromLabel = labels[fromIndex]
        let toLabel = labels[toIndex]
        
        let fromTextWidth = getTextWidth(for: fromLabel)
        let toTextWidth = getTextWidth(for: toLabel)

        let deltaX = toLabel.frame.origin.x - fromLabel.frame.origin.x
        let deltaWidth = toTextWidth - fromTextWidth
        
        
        indicator.center.x = fromLabel.center.x + deltaX * progress
        indicator.frame.size.width = fromTextWidth + deltaWidth * progress
        
    }
    
    func makeColorTransition(fromIndex: Int, toIndex: Int, progress: CGFloat){
        let fromLabel = labels[fromIndex]
        let toLabel = labels[toIndex]
        
        let colorDifferences = UIColor.getRGBDelta(first: barStyle.selectedColor, second: barStyle.normalColor)
        
        let redDiff = colorDifferences.0 * progress
        let greenDiff = colorDifferences.1 * progress
        let blueDiff = colorDifferences.2 * progress
        
        let fromRed = barStyle.selectedColor.getRGBComponents().0 - redDiff
        let fromGreen = barStyle.selectedColor.getRGBComponents().1 - greenDiff
        let fromBlue = barStyle.selectedColor.getRGBComponents().2 - blueDiff
        let fromColor = UIColor(red: fromRed, green: fromGreen, blue: fromBlue, alpha: 1.0)
        
        let toRed = barStyle.normalColor.getRGBComponents().0 + redDiff
        let toGreen = barStyle.normalColor.getRGBComponents().1 + greenDiff
        let toBlue = barStyle.normalColor.getRGBComponents().2 + blueDiff
        let toColor = UIColor(red: toRed, green: toGreen, blue: toBlue, alpha: 1.0)
        
        fromLabel.textColor = fromColor
        toLabel.textColor = toColor
    }
}







