//
//  BKKidModel.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation

enum BKKidConnectionSate: Int {
    case requestSent = 100
    case requestPending = 101
    case connected = 102
    case rejected = 103
}

struct BKProfile {
    let email: String
    let parentName: String
    let city: String
    let state: String
    let phone: String
    let dob: String
}

struct BKKidActivityConnection {

    let date: String
    let gender: String
    let school: String
    let city: String
    let kidname: String
    let age: String
    let id: Int
    
    var connectionState: Int {
        
        didSet {
            
            print( "New connection state is \(connectionState)")
            
            if ( self.connectionState == BKKidConnectionSate.requestSent.rawValue || self.connectionState == BKKidConnectionSate.rejected.rawValue ) {
                
                self.connectionStateDescription = "Pending"
                self.actionLabelHidden = false
                self.btn1Hidden = true
                self.btn2Hidden = true
            }
            else if (self.connectionState == BKKidConnectionSate.requestPending.rawValue ) {
                self.connectionStateDescription = ""
                self.actionLabelHidden = true
                self.btn1Hidden = false
                self.btn2Hidden = false
            }
            else if ( self.connectionState == BKKidConnectionSate.connected.rawValue ) {
                self.connectionStateDescription = "Accepted"
                self.actionLabelHidden = false
                self.btn1Hidden = true
                self.btn2Hidden = true
                
            }

        }
        
    }

    
    var connectionStateDescription: String
    var btn1Hidden: Bool
    var btn2Hidden: Bool
    var actionLabelHidden: Bool
    
    let sport: BKSport?

    init(kidName: String, gender: String, school: String, age: String, sport: BKSport, id: Int, connectionState: BKKidConnectionSate, date: String, city: String, ownerId: Int) {
        self.kidname = kidName
        self.gender = gender
        self.school = school
        self.age = age
        self.sport = sport
        self.id = id
        self.connectionState = connectionState.rawValue
        
        self.date = date
        self.city = city
        
        //to manage status for the tableviewcell
        self.connectionStateDescription = ""
        self.btn1Hidden = false
        self.btn2Hidden = false
        self.actionLabelHidden = false
    }
    
    init(dict: [String: Any]) {
        self.kidname = dict["kidname"] as! String
        self.id = dict["id"] as! Int
        self.gender = dict["gender"] as! String
        self.school = dict["school"] as! String
        self.age = dict["age"] as! String
        //@TODO fix connection state
        self.connectionState = Int(dict["connectionstate"] as! String)!
        self.date = dict["date"] as! String
        self.city = dict["city"] as! String
        var sportName = dict["sportName"] as? String
        
        var skillLevel = dict["skillLevel"] as? String
        
        if sportName == nil {
            sportName = "Chess"
        }
        
        
        if skillLevel == nil  {
            skillLevel = "Rookie"
        }
        
        self.sport = BKSport(dict: ["sportName" : sportName!, "skillLevel": skillLevel!])
        
        //to manage status for the tableviewcell
        self.connectionStateDescription = ""
        self.btn1Hidden = false
        self.btn2Hidden = false
        self.actionLabelHidden = false
        
        
        
    }
    
}


struct BKConnectResponse {
    
    var connresponderKidId: Int
    var responseAcceptStatus: Bool
    var connectionRequestorKidId: Int
    var city: String
    var kidName: String
    var connectionDate: String
    let sport: BKSport?

    init(connresponderKidId: Int, responseAcceptStatus: Bool, connectionRequestorKidId: Int, sport: BKSport, city: String, kidName: String, connectionDate: String) {
        self.connresponderKidId = connresponderKidId
        self.responseAcceptStatus = responseAcceptStatus
        self.connectionRequestorKidId = connectionRequestorKidId
        self.city = city
        self.kidName = kidName
        self.connectionDate = connectionDate
        self.sport = sport
        
    }

    init(dict: [String: Any]) {
        self.connresponderKidId = dict["connresponderkidid"] as! Int
        self.responseAcceptStatus = dict["connResponderacceptance"] as! Bool
        self.connectionRequestorKidId = dict["connectionrequestorkidid"] as! Int
        
        self.city = dict["city"] as! String
        
        self.kidName = dict["kidname"] as! String
        self.connectionDate = dict["connectiondate"] as! String
        
        var sportName = dict["sportname"] as? String
        var skillLevel = dict["skilllevel"] as? String
        
        
        if sportName == nil {
            sportName = "Chess"
        }
        
        if skillLevel == nil {
            skillLevel = "Rookie"
        }
        
        self.sport = BKSport(dict: ["sportName" : sportName!, "skillLevel": skillLevel!])
    }
    
}


struct BKSport: CustomDebugStringConvertible {
    var sportName: String
    var skillLevel: String
    
    
    init(dict: [String: String]) {
        self.sportName = dict["sportName"]!
        self.skillLevel = dict["skillLevel"]!
    }
    
    var debugDescription: String {
        return "{sportName:\(sportName)  skillLevel:\(skillLevel)}"
    }
    
}

struct BKKidModel: CustomDebugStringConvertible {

    var kidName: String
    var id: Int?
    var gender: String
    var school: String
    var sports: [BKSport]
    var age: String
    
    
    init(kidName: String, gender: String, school: String, age: String, sports: [BKSport], id: Int? = nil) {
        self.kidName = kidName
        self.gender = gender
        self.school = school
        self.age = age
        self.sports = sports
        self.id = id
    }
    
    init(dict: [String: Any]) {
        self.kidName = dict["kidName"] as! String
        self.id = dict["id"] as? Int
        self.gender = dict["gender"] as! String
        self.school = dict["school"] as! String
        self.age = dict["age"] as! String
        let sportDict = dict["sport"] as! [[String: String]]
        
        sports = [BKSport]()
        for dict in sportDict {
            let sport = BKSport(dict: dict)
            sports.append(sport)
        }
    }
    
    var debugDescription: String {
        return "kidname:\(kidName) id:\(String(describing: id)) age:\(age) gender:\(gender) school:\(school) sports:\(sports)"
    }
    
    var searchDescription: String {
        return "\(kidName) \(String(describing: id)) \(age) \(gender) \(school) \(sports)"
    }
    
}







