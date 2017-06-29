//
//  AHCategoryContentView.swift
//  AHCategoryVC
//
//  Created by Andy Tong on 5/29/17.
//  Copyright © 2017 Andy Tong. All rights reserved.
//

import UIKit


private let cellID = "cellID"


class AHCategoryContentView: UIView {
    weak var delegate: AHCategoryContentViewDelegate?
    
    fileprivate var childVCs: [UIViewController]
    fileprivate weak var parentVC : UIViewController!
    fileprivate var collectionView: UICollectionView!
    fileprivate lazy var layout = UICollectionViewFlowLayout()
    fileprivate lazy var itemSize: CGSize = self.bounds.size
    fileprivate var initialOffset: CGFloat = 0.0
    
    // should send navBar transitioning progress via delegate, or not
    fileprivate var shouldNotifyNavBarProgress = false

    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AHCategoryContentView {
    func setupUI() {
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        childVCs.forEach { (vc) in
            vc.willMove(toParentViewController: self.parentVC)
            self.parentVC.addChildViewController(vc)
            vc.didMove(toParentViewController: self.parentVC)
        }

        addSubview(collectionView)
    
    }
}

extension AHCategoryContentView: UICollectionViewDelegateFlowLayout {
    
}

extension AHCategoryContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        childVC.view.willMove(toSuperview: cell.contentView)
        cell.contentView.addSubview(childVC.view)
        childVC.view.didMoveToSuperview()

        return cell
    }
}

extension AHCategoryContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialOffset = scrollView.contentOffset.x
        shouldNotifyNavBarProgress = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x != initialOffset, shouldNotifyNavBarProgress else {
            return
        }
        
        // progress relative to the whole screen
        var progress: CGFloat = abs((scrollView.contentOffset.x - initialOffset) / scrollView.bounds.width)
        
        // rounding up
        progress = progress > 0.99 ? 1.0 : progress
        progress = progress < 0.01 ? 0.0 : progress
        
        let itemWidth = itemSize.width + layout.sectionInset.left + layout.sectionInset.right
        let fromIndex: Int = Int(initialOffset / itemWidth)
        var toIndex: Int = 0
        
        if scrollView.contentOffset.x > initialOffset {
            // scroll right -> left
            toIndex = fromIndex + 1
            guard toIndex < childVCs.count else {
                return
            }
        }else{
            // scroll left -> right
            toIndex = fromIndex - 1
            guard toIndex >= 0 else {
                return
            }
        }
        
        delegate?.categoryContentView(self, transitioningFromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard shouldNotifyNavBarProgress else {
            return
        }
        scrollView.isScrollEnabled = true
        handleEndScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            handleEndScrolling()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    
    func handleEndScrolling() {
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        guard index < childVCs.count else {
            return
        }
        
        delegate?.categoryContentView(self, didSwitchIndexTo: index)
        
    }
}



extension AHCategoryContentView: AHCategoryNavBarDelegate {
    
    func categoryNavBar(_ navBar: AHCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        guard toIndex < childVCs.count else {
            return
        }
        
        shouldNotifyNavBarProgress = false
        let indexPath = IndexPath(item: toIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}













