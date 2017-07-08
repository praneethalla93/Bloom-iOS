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
    fileprivate  var kids: [BKKidModel]?
    fileprivate  var currentKid: BKKidModel?
    
    let myGroup = DispatchGroup()
    
    var myKids: [BKKidModel]? {
        
        get {
            return self.kids
        }
        
        set(newKids) {
            self.kids = newKids
            self.currentKid = newKids?[0]
        }

    }

    var myCurrentKid: BKKidModel? {
        
        get {
            return self.currentKid
        }
        
        set(newKid) {
            self.currentKid = newKid
        }

    }
    
    var myProfile: [BKProfile]?
    
    init() {
        //dummy
    }
    
    func request(_ method: HTTPMethod, urlStr: String, parameters: [String: Any],  completion: @escaping (_ success: Bool, _ data: Data?) ->Void ) {
        guard let url = URL(string: urlStr) else{
            print("urlStr error")
            return
        }

        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response: DataResponse) in
            var flag = false
            
            print( "url \(String(describing:  url))")
            print( "Response data \(String(describing:  response.data))")
            
            if let statusCode = response.result.value as? [String: Any] {
                print ("Status Code: \(statusCode)")
                if let code = statusCode["status"] as? Bool {
                    flag = code
                }
                
            }
            
            completion(flag, response.data)
            
            
            if let error = response.result.error as? AFError {
                print("Error code \(error._code)") // statusCode private
                
            }
            
        }
    }
    
    
}


extension BKNetowrkTool {
    
    func addKid(kidModel: BKKidModel, completion: @escaping (_ success: Bool,_ kidid: Int?) -> Void) {
        
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
            print("currentEmail not complete")
            completion(false, nil)
            return
        }
        
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
        
        request(.post, urlStr: BKNetworkingAddKidUrlStr, parameters: dict) { (success, data) in
            
            if success {
                
                    do {
                        if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            
                        if let status = json["status"] as? Bool,
                        let kidid = json["kidid"] as? Int {
                            
                            if self.kids == nil {
                                self.kids = [BKKidModel]()
                            }
                            
                            self.myKids!.append(kidModel)
                            completion(success, kidid)
                        }

                    }
                        
                    print("Success! add kid finished request)")

                } catch {
                    print("Error deserializing JSON: \(error)")
                    print("Failed add kid finished request)")
                    completion(false, nil)
                    
                }
                
            }else{
                completion(false, nil)
            }
                
        }
    }
    
    // If this account haven't added a kid, then the request will be failed
    func getMyKids(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        if self.kids != nil {
            completion(true, self.kids)
            return
        }
        
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
            
                print("Get Kid Finished request")
           
                do {
                        if  let data = data,
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            
                            if let status = json["status"] as? Bool,
                                let kidsDict = json["kids"] as? [[String: Any]] {
                                
                                var kids = [BKKidModel]()
                                for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kids.append(kidModel)
                                print("GetKid name is \(kidModel.kidName)")
                            }
                            
                            self.myKids = kids
                            self.currentKid = self.myKids![0]
                            completion(status, kids)
                        }
                        
                }
                } catch {
                    completion(false, nil)
                }
                
            } else{
                completion(false, nil)
            }

        }
        
    }
    
    
    
    // If this account haven't added a kid, then the request will be failed
    func getKidsFiltered(kidModel:BKKidModel, sportName:String, interestLevel:String, completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        
        var dict = ["kidid": String(describing: kidModel.id)]
        
        if sportName.isEmpty {
            dict["sportname"] = sportName
        }
        
        if interestLevel.isEmpty {
            dict["skilllevel"] = sportName
        }
        
        request(.post, urlStr: BKNetworkingGetKidsFilteredUrlStr, parameters: dict) { (success, data) in
            if success {
           
                print("GeKidFiltered Finished request")
                
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
                            
                            completion(status, kids)
                        }
                        
                    }
                } catch {
                    completion(false, nil)
                }
                
            } else{
                completion(false, nil)
            }
            
        }
        
    }

    func getActivityConnections(completion: @escaping (_ success:Bool, [BKKidActivityConnection]?) -> Void) {
        
        var dict = [String: Any]()
        
        if myCurrentKid != nil {
            dict["kidid"]  = myCurrentKid?.id
        } else {
            completion(false, nil)
        }
        
        request(.post, urlStr: BKNetworkingActivityConnectionUrlStr, parameters: dict) { (success, data) in
            if success {
                print("getActivityConnections Finished request")
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var activityConnections = [BKKidActivityConnection]()
                            
                            for activity in kidsDict {
                                let activityConnect = BKKidActivityConnection(dict: activity)
                                activityConnections.append(activityConnect)
                                print("Activity connection kid name name is \(activityConnect.kidname)")
                            }
                            
                            completion(status, activityConnections)
                        }
                        
                    }
                } catch {
                    completion(false, nil)
                }
                
            } else{
                completion(false, nil)
            }
            
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
        
        var dict = [String:String]()
        dict = ["email": currentEmail!]
        
        request(.post, urlStr: BKNetworkingGetKidUrlStr, parameters: (dict )) { (success, data) in
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var locationKids = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                locationKids.append(kidModel)
                                print("Kid name is \(kidModel.kidName)")
                            }

                            completion(status, locationKids)
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
    
    
    
    func getKidConnections(kidModel:BKKidModel, completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        var dict = [String:Any]()
        dict["kidId"] = kidModel.id
        
        request(.post, urlStr: BKNetworkingConnectionsUrlStr, parameters: dict) { (success, data) in

            
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kidConnections = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kidConnections.append(kidModel)
                                print("Kid name is \(kidModel.kidName)")
                            }
                            
                            completion(status, kidConnections)
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
    
    func connectionRequestor(receivingKid:BKKidModel, connectorKidId:Int, city:String, sportname:String, skilllevel:String, connectionDate:String, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
            print("currentEmail not complete")
            completion(false)
            return
        }
        
        print("currentEmail:\(currentEmail)")
        
        
        var dict = [String: Any]()
        
        dict["kidid"] = receivingKid.id
        dict["kidname"] = receivingKid.kidName
        dict["city"] = city
        dict["connectorkidid"] = connectorKidId
        dict["sportname"] = sportname
        dict["skilllevel"] = skilllevel
        dict["connectiondate"] = connectionDate
        
    
        print("kid info:\(dict)")

        request(.post, urlStr: BKNetworkingConnectionRequestorUrlStr, parameters: dict) { (success, data) in
            if success {
                
                do {
                    
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let status = json["status"] as? Bool {
                            
                            print("ConnectionRequestor Finished request)")
                            completion(status)
                        
                        }
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(false)
                }
                
            }else{
                completion(false)
            }
            
            
        }
    }


    
}
