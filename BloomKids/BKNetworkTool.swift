//
//  BKNetworkTool.swift
//  BloomKids
//
//  Created by Andy Tong on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import Alamofire

enum BKNetworkMethod {
    case POST
    case GET
}

class BKNetowrkTool {
    static let shared = BKNetowrkTool()
    
    func request(_ method: HTTPMethod, urlStr: String, parameters: [String: String],  completion: @escaping (_ success: Bool, _ data: Data?) ->Void ) {
        guard let url = URL(string: urlStr) else{
            print("urlStr error")
            return
        }

        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response: DataResponse) in
            var flag = false
            if let statusCode = response.result.value as? [String: Any] {
                if let code = statusCode["status"] as? Bool {
                    flag = code
                }
            }
            completion(flag, response.data)
            
        }
    }
}
