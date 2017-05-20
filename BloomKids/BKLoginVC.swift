//
//  BKLoginVC.swift
//  BloomKids
//
//  Created by Andy Tong on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD


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
            loginLogoTopSpaceConstraint.constant = BKLoginLogoTopSpace
            OAuthBottomConstraint.constant = 49.0
        }
        
        
    }
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "BKForgotPasswordVC", sender: nil)
    }
    @IBAction func signupBtnTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "BKEmailSignupVC", sender: nil)
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        guard let emailText = emailTextField.text, emailText.characters.count != 0,
                let passwordText = passwordTextField.text, passwordText.characters.count != 0
        else {
            return
        }
        authenticate(emailText, password: passwordText)
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
            textField.resignFirstResponder()
        }
        return true
    }
    
    func authenticate(_ email: String, password: String) {
        guard isValidEmail(testStr: email) else {
            return
        }
        
        SVProgressHUD.show()
        
        BKAuthTool.shared.authenticate(email, password) { (success) in
            if success {
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showError(withStatus: "Your email or password is not matched :(")
            }
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
}






