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
    var currentEmail: String?
    var currentState: String?
    var currentCity: String?

    
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
            
            if let currentCity = currentCity, let currentSate = currentSate  {
                if let currentCity = currentCity, let currentSate = currentSate  {
                    self.currentCity = currentCity
                    self.currentState = currentSate
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navagitionVC = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
                    return navagitionVC
                }
            }
            
            let vc = BKPlaceSearchNavVC()
            vc.placeDelegate = self
            vc.resultType = .city
            vc.placeholder = "Where is your home city?"
            return vc
            
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
        clearKeychain()
        
        let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
        let navagitionVC = authStoryboard.instantiateViewController(withIdentifier: "BKNavigationVC")
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = navagitionVC
    }
    
    func switchToCitySearch() {
        let vc = BKPlaceSearchNavVC()
        vc.placeDelegate = self
        vc.resultType = .city
        vc.placeholder = "Where is your home city?"
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = vc
    }
    
    func clearKeychain() {
        let keychain = Keychain(service: BKKeychainService)
        do {
            if let currentEmail = currentEmail {
                try keychain.remove(currentEmail)
            }
            try keychain.remove(BKCurrentState)
            try keychain.remove(BKCurrentCity)
            try keychain.remove(BKUserEmailKey)
            try keychain.remove(BKHasFinishedTutorial)
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
            if success {
                self.currentEmail = email
                let keychain = Keychain(service: BKKeychainService)
                keychain[email] = password
                keychain[BKUserEmailKey] = email
            }
            completion(success)
        }
        
    }
}



extension BKAuthTool: BKPlaceAutocompleteDelegate {
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC) {
        print("placeAutocompleteDidCancel")
    }
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel) {
        guard let state = place.state else {
            print("AUthTool:placeAutocomplete -> state is nil")
            return
        }
        let keychain = Keychain(service: BKKeychainService)
        keychain[BKCurrentCity] = place.placeName
        keychain[BKCurrentState] = state
        BKAuthTool.shared.switchToMainUI()
        
        
    }
    
    func finishedTutorial() {
        let keychain = Keychain(service: BKKeychainService)
        keychain[BKHasFinishedTutorial] = "true"
        
    }
}













