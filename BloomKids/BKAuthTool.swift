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
}
