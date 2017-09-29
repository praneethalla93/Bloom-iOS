//
//  BKNetworkTool.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess

enum BKNetworkMethod {
    case POST
    case GET
}

class BKNetowrkTool {
    static let shared = BKNetowrkTool()
    fileprivate var kids: [BKKidModel]?
    fileprivate var currentKid: BKKidModel?
    fileprivate var profile: BKProfile?
    var currentEmail: String?
    
    var myKids: [BKKidModel]? {

        get {
            return self.kids
        }
        
        set(newKids) {
            self.kids = newKids
            self.currentKid = newKids?[0]
        }

    }
    
    var myProfile: BKProfile? {
        
        get {
            return self.profile
        }
        
        set(newProfile) {
            self.profile = newProfile
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
    
    func signup(_ email: String, _ password: String, _ parentName: String,_ phone: String, relation: String, completion: @escaping (_ success: Bool, _ statusCode: String) -> Void) {
        
        let parameters = [
            "email": email,
            "parentname": parentName,
            "password": password,
            "phone": phone,
            "relation": relation]
        var statusCode = ""
        
        print("parameters:\(parameters)")
        //request(.post, urlStr: BKNetworkingSignupUrlStr, parameters: parameters) { (success, data) in
            
        request(.post, urlStr: BKNetworkingSignupUrlStr, parameters: parameters) { (success, data) in
            
            if success {
                BKNetowrkTool.shared.currentEmail = email
                let keychain = Keychain(service: BKKeychainService)
                keychain[email] = password
                keychain[BKUserEmailKey] = email
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let statusCodeReturn = json["statuscode"] as? String {
                            statusCode = statusCodeReturn
                        }
                        
                    }
                    
                    print("Success! sign up successful")
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    print("Failed Sign uo finished request)")
                    completion(false, statusCode)
                }

            } else {
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let statusCodeReturn = json["statuscode"] as? String {
                            statusCode = statusCodeReturn
                        }
                        
                    }
                    
                    print("Sign up failed. Error status code received")
                    completion(false, statusCode)
                    return
                } catch {
                    print("Error deserializing JSON: \(error)")
                    print("Failed Sign uo finished request)")
                    completion(false, statusCode)
                }
                
            }
            
            completion(success, statusCode)
        }
        
    }
    
    func authenticate(email: String,password: String, completion: @escaping (_ success: Bool)->Void) {
        
        /*
        var parameter = [String: Any]()
        parameter["email"] = email
        parameter["password"] = password
        */
        let parameter = ["email": email, "password": password]
        print("Parameters : \(parameter)")
        
        request(.post, urlStr: BKNetworkingLoginUrlStr, parameters: parameter) { (success, data) in
            
            //@TODO temporarily disabling authentication
            if success {
                
                print("key chain email set \(email)")
                let keychain = Keychain(service: BKKeychainService)
                self.currentEmail = email
                keychain[BKUserEmailKey] = email
                keychain[email] = password
                completion(success)
            } else {
                completion(false)
            }
            
        }
    }
    
    func addKid(kidModel: BKKidModel, completion: @escaping (_ success: Bool,_ kidid: Int?) -> Void) {
        
        guard let currentEmail = self.currentEmail else {
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
                        
                        var newkidModel = kidModel
                        newkidModel.id = kidid
                        
                        self.myKids!.append(newkidModel)
                        completion(status, kidid)
                    }

                }
                    
                print("Success! Add Kid finished request)")

                } catch {
                    print("Error deserializing JSON: \(error)")
                    print("Failed add kid finished request)")
                    completion(false, nil)

                }

            } else{
                completion(false, nil)
            }
                
        }
    }
    
    func editKid(kidModel: BKKidModel, row: Int, completion: @escaping (_ success: Bool) -> Void) {
        
        var dict = [String: Any]()
        dict["kidid"] = kidModel.id
        dict["kidname"] = kidModel.kidName
        dict["gender"] = kidModel.gender
        dict["dob"] = "01/1/2010"
        dict["age"] = kidModel.age
        dict["school"] = kidModel.school

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
        
        request(.put, urlStr: BKNetworkingEditKidUrlStr, parameters: dict) { (success, data) in
            
            if success {
                
                do {
                    if  let data = data,
                        //let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let _ = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        
                        let newkidModel = kidModel
                        self.myKids?[row] = newkidModel
                        completion(success)
                    }
                    
                    print("Success! edit kid finished request)")
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    print("Failed edit kid )")
                    completion(false)
                }
                
            } else{
                completion(false)
            }
            
        }
    }
    
    // If this account haven't added a kid, then the request will be failed
    func getMyKids(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        if self.kids != nil {
            completion(true, self.kids)
            return
        }
        
        guard let currentEmail = self.currentEmail else {
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
    
    //forgotPassword API call to rest password with Sign In email
    func forgotPassword(email: String, completion: @escaping (_ success:Bool) -> Void) {

        let dict = ["email": email]
        
        request(.post, urlStr: BKNetworkingForgotPasswordUrlStr, parameters: dict) { (success, data) in
            
            if success {
                print("Forgot password request")
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let status = json["status"] as? Bool {
                            completion(status)
                        }

                    }
                } catch {
                    completion(false)
                }

            } else {
                completion(false)
            }
            
        }
        
    }
    
    
    
    // If this account haven't added a kid, then the request will be failed
    func getKidsFiltered(kidModel:BKKidModel, sportName:String, interestLevel:String, completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        
        
        var dict = ["kidid" : String(describing: kidModel.id!)]
        
        if sportName.isEmpty {
            dict["sportname"] = sportName
        }
        
        if interestLevel.isEmpty {
            dict["skilllevel"] = sportName
        }
        
        print("GetKids Filtered dict: \(dict)")
        
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
                                var activityConnect = BKKidActivityConnection(dict: activity)
                                activityConnect.connectionState = activityConnect.connectionState
                                activityConnections.append(activityConnect)
                                print("Activity connection kid name is \(activityConnect.kidname)")
                            }
 
                            activityConnections.sort { (object1, object2) -> Bool in
                                
                                let dateFormatter = DateFormatter()
                                var date1 = Date()
                                var date2 = Date()
                                
                                if ( object1.date.characters.count == 8 ) {
                                    dateFormatter.dateFormat = "MM/dd/yy"
                                    date1 = dateFormatter.date(from: object1.date)!
                                } else if ( object1.date.characters.count == 10 ) {
                                    dateFormatter.dateFormat = "MM/dd/yyyy"
                                    date1 = dateFormatter.date(from: object1.date)!
                                }
                                
                                
                                if ( object2.date.characters.count == 8 ) {
                                    dateFormatter.dateFormat = "MM/dd/yy"
                                    date2 = dateFormatter.date(from: object2.date)!
                                } else if ( object2.date.characters.count == 10 ) {
                                    dateFormatter.dateFormat = "MM/dd/yyyy"
                                    date2 = dateFormatter.date(from: object2.date)!
                                }
                                
                                return (date1 > date2)
                            }
                            
                            completion(status, activityConnections)
                        }
                        
                    }
                    
                } catch {
                    completion(false, nil)
                }

            } else {
                completion(false, nil)
            }
            
        }
    
    }
    
    func getActivityEvents(completion: @escaping (_ success:Bool, [BKKidActivitySchedule]?) -> Void) {
        var dict = [String: Any]()
        
        if myCurrentKid != nil {
            dict["kidid"]  = myCurrentKid?.id
        } else {
            completion(false, nil)
        }
        
        request(.post, urlStr: BKNetworkingActivityScheduleUrlStr, parameters: dict) { (success, data) in
            if success {
                print("getActivityEvents Finished request")
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var activityEvents = [BKKidActivitySchedule]()
                            
                            for activity in kidsDict {
                                
                                var activityEvent = BKKidActivitySchedule(dict: activity)
                                activityEvent.connectionState = activityEvent.connectionState
                                activityEvents.append(activityEvent)
                                print("getActivityEvents kid name name is \(activityEvent.kidName)")
                            }
                            
                            completion(status, activityEvents)
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
        let currentEmail = self.currentEmail
        var dict = [String:String]()
        let keychain = Keychain(service: BKKeychainService)
        
        dict["email"] = currentEmail!
        dict["city"] = "San Francisco"
        dict["state"] = "California"
        
        if let profileCity = self.profile?.city {
            dict["city"] = profileCity
        } else if let profileCity = keychain[BKCurrentCity] {
            dict["city"] = profileCity
        }
        
        if let profileState = self.profile?.state {
            dict["state"] = profileState
        } else if let profileState = keychain[BKCurrentState] {
            dict["state"] = profileState
        }
        
        print("locationdetails Dict \(dict)")
        
        request(.post, urlStr: BKNetworkingLocationDetailsUrlStr, parameters: (dict )) { (success, data) in
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
        
        print("Entering getKid connections")
        
        var dict = [String:Any]()
        dict["kidId"] = kidModel.id
        
        request(.post, urlStr: BKNetworkingConnectionsUrlStr, parameters: dict) { (success, data) in

            if success {
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kidConnections = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kidConnections.append(kidModel)
                                print("Kid name is \(kidModel.kidName)")
                            }
                            
                            completion(success, kidConnections)
                        }
                        
                    }
                    
                } catch {
                    completion(false, nil)
                }
                
            } else {
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        
                        
                        
                        if let status = json["status"] as? Bool {
                            
                            if ( status ) {
                                    completion(true, nil)
                            }
                            else {
                                
                                //TODO:" temporary need to return false for failures.
                                completion(true, nil)
                            }
                        }

                    }
                    
                } catch {
                    print("Error info: \(error)")
                    completion(false, nil)
                }
                
            }

        }
        
    }
    
    func getFamilyDetails(kidId: Int?, email: String?, mode: String, completion: @escaping (_ success:Bool, _ profile: BKProfile?) -> Void) {
        
        var dict = [String:Any]()
        
        if (mode == "EMAIL") {
            
            if let emailAddress = email {
                dict["email"] = emailAddress
            } else {
                dict["email"] = self.currentEmail
            }
            
        } else {
            dict["kidId"] = kidId
        }
        
        
        request(.post, urlStr: BKGetFamilyDetailsUrlStr, parameters: dict) { (success, data) in
            
            if success {
                
                var newProfile: BKProfile
                
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]],
                            let profileDict = json["parent"] as? [String: Any] {
                            
                            var newKids = [BKKidModel]()
                            
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                newKids.append(kidModel)
                            }
                            
                            newProfile = BKProfile(email: self.currentEmail!, dict: profileDict, kids: newKids)
                            
                            //reset profile data only when the current logged in user profile is loaded via email mode.
                            if (mode == "email") {
                                self.profile = newProfile
                            }
                        
                            completion(status, newProfile)
                        }
                        
                    }
                    
                } catch {
                    completion(false, nil)
                }
                
            } else {
                completion(false, nil)
            }
            
        }
        
    }

    
    
    func connectionRequestor(receivingKid:BKKidModel, connectorKidId:Int, city:String, sportname:String, skilllevel:String, connectionDate:String, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let currentEmail = self.currentEmail else {
            print("currentEmail not complete")
            completion(false)
            return
        }
        
        print("currentEmail:\(currentEmail)")
        var dict = [String: Any]()
        
        dict["kidid"] = connectorKidId
        dict["kidname"] = receivingKid.kidName
        dict["city"] = city
        dict["connectorkidid"] = receivingKid.id
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
    
    
    func connectionResponder(connectResponse: BKConnectResponse, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let currentEmail = self.currentEmail else {
            print("currentEmail not complete")
            completion(false)
            return
        }
        
        print("currentEmail:\(currentEmail)")
        var dict = [String: Any]()
        
        dict["connResponderKidId"] = connectResponse.connresponderKidId
        dict["connResponderAcceptance"] = connectResponse.responseAcceptStatus
        dict["connectionRequestorKidId"] =  connectResponse.connectionRequestorKidId
        dict["sportname"] = connectResponse.sport?.sportName
        dict["skilllevel"] = connectResponse.sport?.skillLevel
        dict["city"] =  connectResponse.city
        dict["kidname"] = connectResponse.kidName
        dict["connectiondate"] = connectResponse.connectionDate
        print("kid info:\(dict)")
        
        request(.post, urlStr: BKNetworkingConnectionResponderUrlStr, parameters: dict) { (success, data) in

            if success {

                do {
                    
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let status = json["status"] as? Bool {
                            print("connectionResponder Finished request)")
                            completion(status)
                        }
                        
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(false)
                }
                
            } else {
                completion(false)
            }
            
        }
        
    }
    
    func scheduleResponder(scheduleResponse: BKScheduleResponse, completion: @escaping (_ success: Bool) -> Void) {
        var dict = [String: Any]()
        
        dict["scheduleresponderkidid"] = scheduleResponse.responderKidId
        dict["schedulerequestorkidid"] = scheduleResponse.requesterKidId
        dict["scheduleresponderacceptance"] =  scheduleResponse.acceptanceStatus
        dict["schedulerequestorskilllevel"] =  scheduleResponse.requesterSkillLevel
        dict["schedulerequestorsportname"] =  scheduleResponse.sportName
        dict["schedulerequestorlocation"] =  scheduleResponse.location
        dict["scheduleresponderkidname"] =  scheduleResponse.responderKidName
        dict["schedulerequestortime"] =  scheduleResponse.time
        dict["schedulerequestordate"] =  scheduleResponse.date
        
        print("event response info:\(dict)")
        
        request(.post, urlStr: BKNetworkingScheduleResponderUrlStr, parameters: dict) { (success, data) in
            
            if success {
                
                do {
                    
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let status = json["status"] as? Bool {
                            print("connectionResponder Finished request)")
                            completion(status)
                        }
                        
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(false)
                }
                
            } else {
                completion(false)
            }
            
        }

    }
    
    
    func scheduleEvent(kidName: String, kidId: Int, sportName: String, location: String, responderKidId: Int, eventDate: String, eventTime: String, completion: @escaping (_ success: Bool) -> Void) {

        var dict = [String: Any]()
        dict["schedulerequestorkidname"] = kidName
        dict["schedulerequestorkidid"] = kidId
        dict["schedulerequestorsport"] = sportName
        dict["schedulerequestorlocation"] = location
        dict["scheduleresponderkidid"] = responderKidId
        dict["date"] = eventDate
        dict["time"] = eventTime
        
        print("scheduleEvent parameter info:\(dict)")
        
        request(.post, urlStr: BKNetworkingScheduleRequestorUrlStr, parameters: dict) { (success, data) in
            
            if success {
                
                do {
                    
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let status = json["status"] as? Bool {
                            print("schedule Event  request)")
                            completion(status)
                        }
                        
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(false)
                }
                
            } else {
                completion(false)
            }
            
        }

    }

    
    func cleanObjects() {
        self.kids = nil
        self.currentKid = nil
        self.currentEmail = ""
        self.profile = nil
        BKAuthTool.shared.clearKeychain()
    }
    
    func getGrade(age: String) -> String {
        
        var grade = age
        
        if let intAge = Int(age) {
            
            switch(intAge) {
                
            case 2:
                grade = "Pre-K"
            case 3:
                grade = "Pre-K"
            case 4:
                grade = "Pre-K"
            case 5:
                grade = "Pre-K"
            case 6:
                grade = "1st Grader"
            case 7:
                grade = "2nd Grader"
            case 8:
                grade = "3rd Grader"
            case 9:
                grade = "4th Grader"
            case 10:
                grade = "5th Grader"
            case 11:
                grade = "6th Grader"
            case 12:
                grade = "7th Grader"
            default:
                grade = "Pre-K"
            }
            
        }
        
        return grade
        
    }
    

}
