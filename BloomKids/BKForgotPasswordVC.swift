//
//  BKForgotPasswordVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/18/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var securityCodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var comfirmPasswordField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func resetBtnTapped(_ sender: UIButton) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.characters.count != 0 else {
            return false
        }
        
        if textField === emailField && isValidEmail(testStr: text){
            securityCodeField.becomeFirstResponder()
        }else if textField === securityCodeField{
            passwordField.becomeFirstResponder()
        }else if textField === passwordField{
            comfirmPasswordField.becomeFirstResponder()
        }else if textField === comfirmPasswordField {
            if comfirmPasswordField.text == passwordField.text {
                textField.resignFirstResponder()
            }else{
                print("passwords not matched")
            }
        }
        return true
    }
    
    func resetPassword(_ email: String, securityCode: String, newPassword: String) {
        print("email:\(email) with new password:\(newPassword)")
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }


}
