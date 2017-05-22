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
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var datePickingBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var activeField: UITextField?
    var dateOfBirthStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextFieldsHeightConstraint.constant = BKInputTextFieldHeight
        setupDatePicking()

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
        
        guard let dobText = dateOfBirthField.text, dobText.characters.count != 0 else {
            print("dob incorrect")
            return
        }
        
        guard let passwordText = passwordField.text, passwordText.characters.count != 0 else {
            print("passwrod incorrect")
            return
        }
        var flag = true
        if let phoneText = phoneField.text {
            
            for ch in phoneText.characters {
                if Int(ch.description) == nil {
                    flag = false
                    break
                }
            }
        }
        
        guard flag else {
            print("phone number is incorrect")
            return
        }
        
        SVProgressHUD.show()
        BKAuthTool.shared.signup(emailText, nameText, dobText, passwordText, phoneField.text) { (success) in
            if success {
                SVProgressHUD.showSuccess(withStatus: "Welcome!")
            }else{
                SVProgressHUD.showError(withStatus: "Please check the infomation you just entered")
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        dismissDatePicker()
    }
    
    
    func setupDatePicking() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        datePicker.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(keybordDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BKEmailSignupVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === self.dateOfBirthField {
            self.view.endEditing(true)
            // activeField should be assigned after dimissing the keyboard
            activeField = dateOfBirthField
            showDatePicker()
            return false
        }
        dismissDatePicker()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameField{
            nameField.resignFirstResponder()
            // dateOfBirthField doesn't use system keyboard
            activeField = dateOfBirthField
            showDatePicker()
            return true
        }
        
        
        if textField === emailField && emailField.text!.isValidEmail() {
            nameField.becomeFirstResponder()
        }
        
        
        if textField === passwordField{
            phoneField.becomeFirstResponder()
        }
        
        if textField === phoneField{
            textField.resignFirstResponder()
        }
        dismissDatePicker()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}

//MARK:- Handle Date Picking
// System keyboard height: 216.0, animation duration: 0.25s
// Date Picker fixes height: 216.0
extension BKEmailSignupVC {
    func datePickerValueChanged(_ picker: UIDatePicker) {
        dateOfBirthField.text = datePickerForString()
    }
    
    func keybordDidHide(_ note: Notification) {
        showDatePicker()
    }

    func dismissDatePicker() {
        guard datePickingBottomConstraint.constant >= 0.0 else {
            return
        }
        
        datePickingBottomConstraint.constant = -CGFloat(216.0)
        UIView.animate(withDuration: 0.25, animations: { 
            self.view.layoutIfNeeded()
        }) { (_) in
            
            self.dateOfBirthStr = self.datePickerForString()
        }
    
    }
    
    func showDatePicker() {
        if activeField === dateOfBirthField {
            datePickingBottomConstraint.constant = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    func datePickerForString() -> String {
        let calendar = self.datePicker.calendar!
        let date = self.datePicker.date
        let month = calendar.component(Calendar.Component.month, from: date)
        let day = calendar.component(Calendar.Component.day, from: date)
        let year = calendar.component(Calendar.Component.year, from: date)
        return "\(month)/\(day)/\(year)"
    }
}






