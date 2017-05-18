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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        print("forgotPasswordTapped")
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
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
        
        if textField === self.emailTextField {
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
}






