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
    
    func viewControllerForWindow() -> UIViewController {

        let keychain = Keychain(service: BKKeychainService)
        if let emailStr = try? keychain.getString(BKUserEmailKey), let email = emailStr {
            currentEmail = email
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
            
            // check if this user already chose a home city
            let currentCity = try? keychain.getString(BKCurrentCity)
            let currentSate = try? keychain.getString(BKCurrentState)
            
            BKAuthTool.shared.switchToCitySearch()
            if let currentCity = currentCity, let currentSate = currentSate  {
                if let _ = currentCity, let _ = currentSate  {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navagitionVC = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
                    return navagitionVC
                }
            }
            
            let storyboard = UIStoryboard(name: "BKCitySearch", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            return vc!
            
        }else{
            let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
            let navagitionVC = authStoryboard.instantiateViewController(withIdentifier: "BKNavigationVC")
            return navagitionVC
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
    
    func switchToCitySearch() {
        let storyboard = UIStoryboard(name: "BKCitySearch", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = vc
    }
    
    func clearKeychain(_ currentEmail: String = "") {
        let keychain = Keychain(service: BKKeychainService)
        do {
            try keychain.remove(currentEmail)
            try keychain.remove(BKCurrentState)
            try keychain.remove(BKCurrentCity)
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
    
    func signup(_ email: String, _ password: String, _ parentName: String,_ phone: String, relation: String, completion: @escaping (_ success: Bool)->Void) {
        let parameters = [
            "email": email,
            "parentname": parentName,
            "password": password,
            "phone": phone,
            "relation": relation]
        print("parameters:\(parameters)")
        BKNetowrkTool.shared.request(.post, urlStr: BKNetworkingSignupUrlStr, parameters: parameters) { (success, data) in
            completion(success)
        }
        
    }
}
