//
//  BKAuthTool.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import KeychainAccess
import SVProgressHUD

class BKAuthTool {
    
    static let shared = BKAuthTool()
    var currentState: String?
    var currentCity: String?
    var showViewController: UIViewController?
    var authVC: BKNavigationVC?
    
    func viewControllerForWindow() -> UIViewController? {
        
        let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
        
        //Scenario 1. The user will be shown Auth UI if he does not already have the credentials.
        //Scenario 2. The user will be shown Main UI if he already has the credentials with successful login
        //Scenario 3. The user will be shown Auth UI if he already has the credentials with failed login
        showViewController = authStoryboard.instantiateViewController(withIdentifier: "BKNavigationVC")
        let keychain = Keychain(service: BKKeychainService)
        
        if let emailStr = try? keychain.getString(BKUserEmailKey), let email = emailStr {
            BKNetowrkTool.shared.currentEmail = email
            
            // give it a little delay so that it doesn't have to race with the code after this block
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                if let passwordStr = try? keychain.getString(email), let password = passwordStr {
                    
                    BKNetowrkTool.shared.authenticate(email: email, password: password, completion: { (success) in
                        
                        if success {
                            
                            //let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            //showViewController = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
                            self.switchToMainUI()
                        }else{
                            SVProgressHUD.showError(withStatus: "Login failed")
                            //TODO: login failed. stay in Auth UI
                            self.switchToAuthUI()
                        }

                    })
                    
                } else {
                    SVProgressHUD.showError(withStatus: "password not in keychain")
                    self.switchToAuthUI()
                }

            })
            
            // check if this user already chose a home city
            /*
            let currentCity = try? keychain.getString(BKCurrentCity)
            let currentSate = try? keychain.getString(BKCurrentState)
            
            if let currentCity = currentCity, let currentSate = currentSate  {
                self.currentCity = currentCity
                self.currentState = currentSate
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navagitionVC = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
                return navagitionVC
                
            }else{
                let vc = BKPlaceSearchNavVC()
                vc.placeDelegate = self
                vc.resultType = .city
                vc.placeholder = "Where is your home city?"
                return vc
            }
            */
        }

        return showViewController
    }
    
    func switchToMainUI() {
        
        //create profile if it's empty
        if BKNetowrkTool.shared.myProfile == nil {
            
            BKNetowrkTool.shared.getFamilyDetails(kidId: BKNetowrkTool.shared.myCurrentKid?.id, email: BKNetowrkTool.shared.currentEmail, mode: "EMAIL", completion: { (success, profile) in
                
                if success {
                    //TODO: access profile data if needed
                    BKNetowrkTool.shared.myProfile = profile
                } else {
                    SVProgressHUD.showError(withStatus: "Profile load failed")
                    print("Profile load failed")
                    //TODO: login failed. stay in Auth UI
                    //self.switchToAuthUI()s
                }
                
            })

        }

        //whether profile loads or not we want to proceed as the user is already authenticated
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navagitionVC = mainStoryboard.instantiateViewController(withIdentifier: "BKMainTabBarVC")
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = navagitionVC
       
    }
    
    func switchToAuthUI() {
        let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
        authVC = authStoryboard.instantiateViewController(withIdentifier: "BKNavigationVC") as? BKNavigationVC
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = authVC
    }
    
    func switchToCitySearch() {
        let vc = BKPlaceAutocompleteVC()
        //vc.placeDelegate = self
        vc.delegate = self
        vc.resultType = .city
        vc.placeholder = "What's your home city?"
        //let window = UIApplication.shared.keyWindow
        //window?.rootViewController = vc
        authVC?.pushViewController(vc, animated: false)
    }
    
    func switchToCongratsUI() {
        let authStoryboard = UIStoryboard(name: "BKAuth", bundle: nil)
        let congratsVC = authStoryboard.instantiateViewController(withIdentifier: "BKCongratsVC")
        authVC?.pushViewController(congratsVC, animated: false)
    }
    
    func switchToAddKidUI() {
        let profileStoryboard = UIStoryboard(name: "BKProfile", bundle: nil)
        let addKidVC = profileStoryboard.instantiateViewController(withIdentifier: "BKAddKidVC") as! BKAddKidVC
        addKidVC.mode = "ONBOARD"
        authVC?.pushViewController(addKidVC, animated: false)
    }
    
    func switchToConnectPlayerUI(navigationController: UINavigationController?) {
        let connectStoryboard = UIStoryboard(name: "BKConnect", bundle: nil)
        let connectPlayerVC = connectStoryboard.instantiateViewController(withIdentifier: "BKConnectPlayerVC")
        navigationController?.pushViewController(connectPlayerVC, animated: false)
    }
    
    func clearKeychain() {
        
        let keychain = Keychain(service: BKKeychainService)
        do {
            if let currentEmail = BKNetowrkTool.shared.currentEmail {
                try keychain.remove(currentEmail)
            }
            try keychain.remove(BKCurrentState)
            try keychain.remove(BKCurrentCity)
            try keychain.remove(BKUserEmailKey)
        } catch _ {
            
        }
    }
    
    func logout() {
        clearKeychain()
        BKNetowrkTool.shared.cleanObjects()
        switchToAuthUI()
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

        switchToCongratsUI()
        
    }
    
    func finishedOnboarding() {
        let keychain = Keychain(service: BKKeychainService)
        keychain[BKHasFinishedOnboarding] = "true"
    }

}











