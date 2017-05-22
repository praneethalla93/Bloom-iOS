//
//  BKAuthTool.swift
//  BloomKids
//
//  Created by Andy Tong on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import KeychainAccess
import SVProgressHUD

class BKAuthTool {
    static let shared = BKAuthTool()
    var currentEmail: String = ""
    func shouldSwitchToMain() -> Bool{
        let keychain = Keychain(service: BKKeychainService)
        if let emailStr = try? keychain.getString(BKUserEmailKey), let email = emailStr {
            currentEmail = email
//            SVProgressHUD.show()
            DispatchQueue.main.async {
                if let passwordStr = try? keychain.getString(email), let password = passwordStr{
                    self.authenticate(email, password, completion: { (success) in
                        if success {
//                            SVProgressHUD.dismiss()
                        }else{
                            SVProgressHUD.showError(withStatus: "login failed")
                            self.switchToAuthUI()
                        }
                    })
                }else{
                    SVProgressHUD.showError(withStatus: "password not in keychain")
                    self.switchToAuthUI()
                }
                
            }
            
            return true
        }else{
            return false
        }
    }
    
    func switchToMainUI() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navagitionVC = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = navagitionVC
    }
    
    func switchToAuthUI() {
        clearKeychain(currentEmail)
        
        let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
        let navagitionVC = authStoryboard.instantiateViewController(withIdentifier: "BKNavigationVC")
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = navagitionVC
    }
    
    func clearKeychain(_ currentEmail: String = "") {
        let keychain = Keychain(service: BKKeychainService)
        do {
            try keychain.remove(currentEmail)
            try keychain.remove(BKUserEmailKey)
        } catch _ {
            
        }
    }
    
    func logout() {
        switchToAuthUI()
    }
    
    func authenticate(_ email: String, _ password: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = ["email": email, "password": password]
        BKNetowrkTool.shared.request(.post, urlStr: BKNetworkingLoginUrlStr, parameters: parameter) { (success, data) in
            if success {
                let keychain = Keychain(service: BKKeychainService)
                self.currentEmail = email
                keychain[email] = password
                keychain[BKUserEmailKey] = email
            }
            
            completion(success)
        }
    }
    
    func signup(_ email: String, _ parentName: String, _ dateOfBirth: String, _ password: String, _ phone: String?, completion: @escaping (_ success: Bool)->Void) {
        var parameters = ["email": email,
        "parentname": parentName,
        "dob": dateOfBirth,
        "password": password]
        
        if let phoneNumber = phone {
            parameters["phone"] = phoneNumber
        }
        
        BKNetowrkTool.shared.request(.post, urlStr: BKNetworkingSignupUrlStr, parameters: parameters) { (success, data) in
            completion(success)
        }
        
    }
}
