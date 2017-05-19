//
//  BKLoginVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

let fakeEmail = "123@gmail.com"
let fakePassword = "123"



class BKLoginVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var OAuthBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginLogoTopSpaceConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = UIScreen.main.bounds.size
        if size.height < 481.0 {
            // iPhone 4S, iPad Air, and all devices using @1x resolution
            loginLogoTopSpaceConstraint.constant = 8.0
            OAuthBottomConstraint.constant = 0.0
        }else{
            loginLogoTopSpaceConstraint.constant = 20
            OAuthBottomConstraint.constant = 49.0
        }
        
    }
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        print("forgotPasswordTapped")
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        guard let emailText = emailTextField.text, emailText.characters.count != 0,
                let passwordText = passwordTextField.text, passwordText.characters.count != 0
        else {
            return
        }
        authenticate(emailText, password: passwordText)
        print("loginBtnTapped")
    }
    @IBAction func loginFBTapped(_ sender: UIButton) {
        print("loginFBTapped")
    }
    @IBAction func loginGoogleTapped(_ sender: UIButton) {
        print("loginGoogleTapped")
    }
    

}


//MARK:- Setups
extension BKLoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.characters.count != 0 else {
            return false
        }
        
        if textField === self.emailTextField && isValidEmail(testStr: text){
            self.passwordTextField.becomeFirstResponder()
        }else{
            authenticate(self.emailTextField.text!, password: self.passwordTextField.text!)
        }
        return true
    }
    
    func authenticate(_ email: String, password: String) {
        if email == fakeEmail && password == fakePassword {
            print("ok")
        }else{
            print("failed")
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
}






