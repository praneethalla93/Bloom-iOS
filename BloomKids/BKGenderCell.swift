//
//  BKGenderCell.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit


class BKGenderCell: UITableViewCell {
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var boyBtn: UIButton!
    
    var didSelectGenderBtn: ( (_ genderStr: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGenderBtns()
        setGenderBtnSelected(button: boyBtn)
        setGenderBtnNormal(button: girlBtn)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.didSelectGenderBtn?("boy")
        }
    }
    
    
    

    @IBAction func genderBtnTapped(_ sender: UIButton) {
        if sender === boyBtn {
            setGenderBtnSelected(button: boyBtn)
            setGenderBtnNormal(button: girlBtn)
        }else{
            setGenderBtnSelected(button: girlBtn)
            setGenderBtnNormal(button: boyBtn)
        }
    }

    
    func setupGenderBtns() {
        boyBtn.sizeToFit()
        boyBtn.tag = 0
        boyBtn.layer.masksToBounds = true
        boyBtn.layer.cornerRadius = boyBtn.bounds.size.height / 2
        
        girlBtn.sizeToFit()
        girlBtn.tag = 1
        girlBtn.layer.masksToBounds = true
        girlBtn.layer.cornerRadius = girlBtn.bounds.size.height / 2
        
    }
    func setGenderBtnNormal(button: UIButton) {
        button.layer.borderColor = BKGlobalTintColor.cgColor
        button.layer.borderWidth = 2.0
        button.setTitleColor(BKGlobalTintColor, for: UIControlState.normal)
        button.backgroundColor = UIColor.white
    }
    func setGenderBtnSelected(button: UIButton) {
        let genderStr = (button.tag == 0) ? "boy" : "girl"
        didSelectGenderBtn?(genderStr)
        
        button.layer.borderColor = BKGlobalTintColor.cgColor
        button.layer.borderWidth = 2.0
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = BKGlobalTintColor
    }
}
