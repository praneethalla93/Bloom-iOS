//
//  BKEmailSignupVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/18/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEmailSignupVC: UIViewController {
    @IBOutlet weak var inputTextFieldsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextFieldsHeightConstraint.constant = BKInputTextFieldHeight

    }

    
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension BKEmailSignupVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === self.dateOfBirthField {
            handleDatePicking()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField {
            nameField.becomeFirstResponder()
        }
        
        if textField === nameField{
            nameField.resignFirstResponder()
            handleDatePicking()
        }
        
        if textField === passwordField{
            phoneField.becomeFirstResponder()
        }
        
        if textField === phoneField{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension BKEmailSignupVC {
    func handleDatePicking() {
        print("handleDatePicking")
    }
}






