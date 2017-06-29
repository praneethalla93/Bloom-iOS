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
    var myKids = [BKKidModel]()
    
    func request(_ method: HTTPMethod, urlStr: String, parameters: [String: Any],  completion: @escaping (_ success: Bool, _ data: Data?) ->Void ) {
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


extension BKNetowrkTool {
    
    func addKid(kidModel: BKKidModel, completion: @escaping (_ sucess: Bool,_ kidid: Int?) -> Void) {
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
        print("currentEmail not complete")
        completion(false, nil)
        return
    }
        
        /*
         var kidName: String
         var id: String
         var gender: String
         var school: String
         var sports: [BKSport]
         var age: Int
        */
        
        var dict = [String: Any]()
        dict["kidname"] = kidModel.kidName
        dict["gender"] = kidModel.gender
        dict["school"] = kidModel.school
        dict["age"] = kidModel.age
        dict["email"] = currentEmail
        print("currentEmail:\(currentEmail)")
        var sportArr = [[String: String]]()
        /*
         var sportName: String
         var interestLevel: String
         var skillLevel: String
        */
        for sport in kidModel.sports {
            var sportDict = [String: String]()
            sportDict["sportname"] = sport.sportName
            sportDict["skilllevel"] = sport.skillLevel
            
            sportArr.append(sportDict)
        }
        
        dict["sport"] = sportArr
        
        print("kid info:\(dict)")
        
        //let myGroup = DispatchGroup()
        //myGroup.enter()
        
        
        request(.post, urlStr: BKNetworkingAddKidUrlStr, parameters: dict) { (success, data) in
        if success {
            
                do {

            
                    if  let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let status = json["status"] as? Bool,
                    let kidid = json["kidid"] as? Int {
                        self.myKids.append(kidModel)
                        completion(status, kidid)
                    }
                        
                }
            } catch {
                print("Error deserializing JSON: \(error)")
                completion(false, nil)
            }
            
        }else{
            completion(false, nil)
        }
            
            print("Add kid Finished request)")
            //myGroup.leave()
            
        }
    }
    
    // If this account haven't added a kid, then the request will be failed
    func getKids(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
            print("currentEmail not complete")
            completion(false, nil)
            return
        }
        
        let dict = ["email": currentEmail]
        
        //let myGroup = DispatchGroup()
        //myGroup.enter()
        
        
        request(.post, urlStr: BKNetworkingGetKidUrlStr, parameters: dict) { (success, data) in
            if success {
            
            /*
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            */
            
            print("Get Kid Finished request")
           
                do {
                        if  let data = data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        {
                            if let status = json["status"] as? Bool,
                                let kidsDict = json["kids"] as? [[String: Any]] {
                            
                                    var kids = [BKKidModel]()
                                    for kidDict in kidsDict {
                                    let kidModel = BKKidModel(dict: kidDict)
                                    kids.append(kidModel)
                                    print("GetKid name is \(kidModel.kidName)")
                            }
                            
                                self.myKids = kids
                                completion(status, kids)
                        }
                        
                }
                } catch {
                    completion(false, nil)
                }
                
            } else{
                completion(false, nil)
            }
            
            //print("Get kid Finished request)")
            //myGroup.leave()
                
        }
        
    }

    func getActivityConnections(for kidId: Int, completion: ([BKKidActivityConnection]?) -> Void) {
        request(.post, urlStr: BKNetworkingActivityConnectionUrlStr, parameters: ["kidid": kidId]) { (success, data) in
            
        }
    }
    
    
    func locationDetails(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        let currentEmail = BKAuthTool.shared.currentEmail
        
        /*
        guard let currentEmail = BKAuthTool.shared.currentEmail,
        let currentState = BKAuthTool.shared.currentState,
        let currentCity = BKAuthTool.shared.currentCity else {
            print("current emial or state or city not complete")
            //completion(false, nil)
            //Raj do n't need to return for no city or email.
            //return
            break
        }
        */
        // let param be just email for getkids
        /*
        let dict = ["email": currentEmail,
                    "city": currentCity,
                    "state": currentState]
        */
        
        let dict = ["email": currentEmail]
        
        request(.post, urlStr: BKNetworkingGetKidUrlStr, parameters: dict) { (success, data) in
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kids = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kids.append(kidModel)
                                print("Kid name is \(kidModel.kidName)")
                            }
                            

                            
                            completion(status, kids)
                        }
                        
                    }
                    
                } catch {
                    completion(false, nil)
                }
                
            }else{
                completion(false, nil)
            }

        }
        
    }
    
    
    
    func getKidConnections(_ kidId:Int ,completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        //let currentEmail = BKAuthTool.shared.currentEmail
        //let kidId =
       
        
        let dict = ["kidId": kidId]
        
        request(.post, urlStr: BKNetworkingConnectionsUrlStr, parameters: dict) { (success, data) in
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kids = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kids.append(kidModel)
                                print("Kid name is \(kidModel.kidName)")
                            }
                            
                            
                            
                            completion(status, kids)
                        }
                        
                    }
                    
                } catch {
                    completion(false, nil)
                }
                
            }else{
                completion(false, nil)
            }
            
        }
        
    }

    
}
