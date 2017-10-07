//
//  BKLoginVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainAccess

let fakeEmail = "123@gmail.com"
let fakePassword = "123"
let myGroup = DispatchGroup()

class BKLoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var facebookLoginBtn: UIButton!
    
    //@IBOutlet weak var OAuthBottomConstraint: NSLayoutConstraint!
    //@IBOutlet weak var loginLogoTopSpaceConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let size = UIScreen.main.bounds.size
        
        
        if size.height < 481.0 {
            
            // iPhone 4S, iPad Air, and all devices using @1x resolution
            loginLogoTopSpaceConstraint.constant = 8.0
            OAuthBottomConstraint.constant = 0.0
        }else{
           // loginLogoTopSpaceConstraint.constant = BKLoginLogoTopSpace
          //  OAuthBottomConstraint.constant = 49.0
        }
        */

        //TODO: temporarily hiding Google and Facebook Btn
        googleLoginBtn.isHidden = true
        facebookLoginBtn.isHidden = true

        //initial email and password from key chain.
        
        let keychain = Keychain(service: BKKeychainService)
        
        if let emailStr = try? keychain.getString(BKUserEmailKey), let email = emailStr {
            emailTextField.text = email
            
            if let passwordStr = try? keychain.getString(email), let password = passwordStr {
                passwordTextField.text = password
            }
        }

    }

    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "BKForgotPasswordVC", sender: nil)
    }
    

    @IBAction func signupBtnTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "BKEmailSignupVC", sender: nil)
    }
  
    
    @IBAction func signupBtnFormTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "BKEmailSignupVC", sender: nil)
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        guard let emailText = emailTextField.text, emailText.characters.count != 0,
            let passwordText = passwordTextField.text, passwordText.characters.count != 0
        else {
            return
        }

        myGroup.enter()
        BKAuthTool.shared.updateKeyChain(email: emailText, password: passwordText)
        authenticate(emailText, password: passwordText)
        
        //TODO to activities after login.
        myGroup.notify(queue: .main) {
            
        }
    }
    
    @IBAction func loginFBTapped(_ sender: UIButton) {
        print("loginFBTapped")
    }
    
    @IBAction func loginGoogleTapped(_ sender: UIButton) {
        print("loginGoogleTapped")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}


//MARK:- Setups
extension BKLoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.characters.count != 0 else {
            return false
        }
        
        guard text.isValidEmail() else {
            SVProgressHUD.showError(withStatus: "Invalid Email address")
            return false
        }

        if textField === self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    func authenticate(_ email: String, password: String) {
        
        guard email.isValidEmail() else {
            return
        }

        SVProgressHUD.show()
        BKNetowrkTool.shared.authenticate(email: email, password: password) { (success) in
            
            if success {
                SVProgressHUD.dismiss()
                myGroup.leave()
                // check if this user already chose a home city
                let keychain = Keychain(service: BKKeychainService)
                let currentCity = try? keychain.getString(BKCurrentCity)
                let currentSate = try? keychain.getString(BKCurrentState)
                
                if let currentCity = currentCity, let currentSate = currentSate  {
                    if let _ = currentCity, let _ = currentSate  {
                        BKAuthTool.shared.switchToMainUI()
                    }
   
                }

                //Raj: added to switch to main UI.
                BKAuthTool.shared.switchToMainUI()
            } else {
                SVProgressHUD.showError(withStatus: "Your email or password is incorrect. Try resetting your password")
                myGroup.leave()
            }

            /*
            SVProgressHUD.dismiss()
            // check if this user already chose a home city
            let keychain = Keychain(service: BKKeychainService)
            let currentCity = try? keychain.getString(BKCurrentCity)
            let currentSate = try? keychain.getString(BKCurrentState)
            
            if let currentCity = currentCity, let currentSate = currentSate  {
                if let _ = currentCity, let _ = currentSate  {
                    BKAuthTool.shared.switchToMainUI()
                }
                
            }
            */
        }

    }

}
