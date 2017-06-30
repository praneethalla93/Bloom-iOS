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
    case requestReceived
    case connected
    case rejected
}


struct BKKidActivityConnection {
    var ownerId: Int?
    
    let date: String
    let gender: String//
    let school: String//
    let city: String
    let id: Int//
    let connectionState: BKKidConnectionSate
    let sport: BKSport//
    let kidname: String //
    let age: String//
    
    
    init(kidName: String, gender: String, school: String, age: String, sport: BKSport, id: Int, connectionState: BKKidConnectionSate, date: String, city: String, ownerId: Int) {
        self.kidname = kidName
        self.gender = gender
        self.school = school
        self.age = age
        self.sport = sport
        self.id = id
        self.connectionState = connectionState
        self.date = date
        self.ownerId = ownerId
        self.city = city
    }
    
    init(dict: [String: Any]) {
        self.kidname = dict["kidName"] as! String
        self.id = dict["id"] as! Int
        self.gender = dict["gender"] as! String
        self.school = dict["school"] as! String
        self.age = dict["age"] as! String
        self.connectionState = dict["connectionstate"] as! BKKidConnectionSate
        self.date = dict["date"] as! String
        self.city = dict["city"] as! String
        
        let sportName = dict["sportname"] as! String
        let skillLevel = dict["skilllevel"] as! String
        self.sport = BKSport(dict: ["sportName" : sportName, "skillLevel": skillLevel])
        
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
    
    /* {"gender":"boy",
     "school":"Free school",
     "id":87,
     "kidName":"The son of Stone",
     "sport":[{
                "sportName":"Call of Duty",
                "skillLevel":"10^100"}],
     "age":"10"}
 
 */
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
    
}







