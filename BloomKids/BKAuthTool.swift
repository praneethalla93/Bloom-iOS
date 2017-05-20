//
//  BKAuthTool.swift
//  BloomKids
//
//  Created by Andy Tong on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation

class BKAuthTool {
    static let shared = BKAuthTool()
    
    func authenticate(_ email: String, _ password: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = ["email": email, "password": password]
        BKNetowrkTool.shared.request(.post, urlStr: BKNetworkingLoginUrlStr, parameters: parameter) { (success, data) in
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
