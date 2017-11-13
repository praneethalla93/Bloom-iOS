//
//  BKEmailSignupVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/18/17.
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
    
    var signUpSuccessFlag = false
    
    var signUpTestFlag = false
    let myGroup = DispatchGroup()

    weak var currentGender: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //inputTextFieldsHeightConstraint.constant = BKInputTextFieldHeight
        setupGenderBtns()
        self.signUpSuccessFlag = false
        
        if signUpTestFlag {
            //emailField.text = "jill.johnson2@gmail.com"
            //emailField.text = "raj.sathyaseelan@gmail.com"
            emailField.text = "bloomkidsports@gmail.com"
            passwordField.text = "Bloom123"
            comfirmPassword.text = "Bloom123"
            nameField.text = "Jimmy Buck"
            phoneField.text = "415.917.9672"
        }

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
            SVProgressHUD.showError(withStatus: "email address is incorrect")
            return
        }
        
        guard let nameText = nameField.text, nameText.characters.count != 0 else {
            print("name incorrect")
            SVProgressHUD.showError(withStatus: "parent name is incorrect")
            return
        }
        
        
        guard let passwordText = passwordField.text, passwordText.characters.count != 0 else {
            print("passwrod incorrect")
            SVProgressHUD.showError(withStatus: "Password is empty.")
            return
        }
        
        guard let comfirmText = comfirmPassword.text, comfirmText.characters.count != 0, comfirmText == passwordText else {
            SVProgressHUD.showError(withStatus: "Password does not match.")
            return
        }
        
        guard let phoneStr = phoneField.text, phoneStr.characters.count != 0 else {
            print("phone # incorrect")
            SVProgressHUD.showError(withStatus: "Phone number is empty")
            return
        }
        
        let genderStr = currentGender.titleLabel!.text!
        
        self.myGroup.enter()
        
        SVProgressHUD.show()
        
        BKNetowrkTool.shared.signup(emailText, passwordText, nameText, phoneStr, relation: genderStr) { (success, statusCode) in
            
            if success {
                SVProgressHUD.showSuccess(withStatus: "Welcome!")
                BKNetowrkTool.shared.currentEmail = emailText
                
                BKAuthTool.shared.updateKeyChain(email: emailText, password: passwordText)
                self.signUpSuccessFlag = true
                self.myGroup.leave()
            } else {
                
                if (statusCode == "210") {
                    SVProgressHUD.showError(withStatus: "Email Id already signed up. Try forgot password.")
                } else {
                    SVProgressHUD.showError(withStatus: "Please check the infomation you just entered")
                }

                self.myGroup.leave()
            }
            
            //after successfullly loading data
            self.myGroup.notify(queue: .main) {
                print("Finished all requests.")
         
                 if BKNetowrkTool.shared.currentEmail != nil && self.signUpSuccessFlag {
                     BKAuthTool.shared.switchToCitySearch()
                 }

            }
            
        }
 
         /*
        //TODO temporary diversion
        SVProgressHUD.showSuccess(withStatus: "Welcome!")
        BKNetowrkTool.shared.currentEmail = emailText
        BKAuthTool.shared.switchToCitySearch()
        */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}


//MARK:- TextField related
/*
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
 */






