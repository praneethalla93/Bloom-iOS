//
//  BKEmailSignupVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/18/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class BKEmailSignupVC: UIViewController {
    @IBOutlet weak var inputTextFieldsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var comfirmPassword: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fatherBtn: UIButton!
    @IBOutlet weak var motherBtn: UIButton!

    weak var currentGender: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextFieldsHeightConstraint.constant = BKInputTextFieldHeight
        setupGenderBtns()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGenderBtnSelected(button: fatherBtn)
        setGenderBtnNormal(button: motherBtn)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}


//MARK:- Setups
extension BKEmailSignupVC {
    func setupGenderBtns() {
        fatherBtn.layer.masksToBounds = true
        fatherBtn.layer.cornerRadius = fatherBtn.bounds.size.height / 2
        
        motherBtn.layer.masksToBounds = true
        motherBtn.layer.cornerRadius = fatherBtn.bounds.size.height / 2
        
    }
    func setGenderBtnNormal(button: UIButton) {
        button.layer.borderColor = BKGlobalTintColor.cgColor
        button.layer.borderWidth = 2.0
        button.setTitleColor(BKGlobalTintColor, for: UIControlState.normal)
        button.backgroundColor = UIColor.white
    }
    func setGenderBtnSelected(button: UIButton) {
        currentGender = button
        button.layer.borderColor = BKGlobalTintColor.cgColor
        button.layer.borderWidth = 2.0
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = BKGlobalTintColor
    }
}


//MARK:- Controls
extension BKEmailSignupVC {
    @IBAction func genderTapped(_ sender: UIButton) {
        if sender === fatherBtn {
            setGenderBtnSelected(button: fatherBtn)
            setGenderBtnNormal(button: motherBtn)
        }else{
            setGenderBtnSelected(button: motherBtn)
            setGenderBtnNormal(button: fatherBtn)
        }
    }
    
    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        guard let emailText = emailField.text, emailText.isValidEmail() else {
            print("email incorrect")
            return
        }
        
        guard let nameText = nameField.text, nameText.characters.count != 0 else {
            print("name incorrect")
            return
        }
        
        
        guard let passwordText = passwordField.text, passwordText.characters.count != 0 else {
            print("passwrod incorrect")
            return
        }
        
        guard let comfirmText = comfirmPassword.text, comfirmText.characters.count != 0, comfirmText == passwordText else {
            print("passwordText not matched")
            return
        }
        
        guard let nameStr = nameField.text, nameStr.characters.count != 0 else {
            print("name is incorrect")
            return
        }
        
        guard let phoneStr = phoneField.text, phoneStr.characters.count != 0 else {
            print("phone # incorrect")
            return
        }
        
        var flag = true
        for ch in phoneStr.characters {
            if Int(ch.description) == nil {
                flag = false
                break
            }
        }
        
        guard flag else {
            print("phone number is incorrect")
            return
        }
        
        let genderStr = currentGender.titleLabel!.text!
        
        SVProgressHUD.show()
        BKAuthTool.shared.signup(emailText, passwordText, nameText, phoneStr, relation: genderStr) { (success) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "Welcome!")
                BKAuthTool.shared.switchToCitySearch()
            }else{
                SVProgressHUD.showError(withStatus: "Please check the infomation you just entered")
            }
        }
        
    }
}


//MARK:- TextField related
extension BKEmailSignupVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameField{
            nameField.resignFirstResponder()
        }
        
        if textField === emailField && emailField.text!.isValidEmail() {
            nameField.becomeFirstResponder()
        }
        
        if textField === passwordField{
            comfirmPassword.becomeFirstResponder()
        }
        
        if textField === comfirmPassword {
            if let comfirmText = comfirmPassword.text, comfirmText.characters.count != 0, comfirmText == passwordField.text {
                nameField.becomeFirstResponder()
                return true
            }else{
                return false
            }
        }
        
        if textField === nameField {
            phoneField.becomeFirstResponder()
        }
        
        if textField === phoneField{
            textField.resignFirstResponder()
        }

        return true
    }
    
}






