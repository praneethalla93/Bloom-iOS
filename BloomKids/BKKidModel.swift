//
//  BKKidModel.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation

struct BKSport: CustomDebugStringConvertible {
    var sportName: String
    var interestLevel: String
    var skillLevel: String
    
    
    init(dict: [String: String]) {
        self.sportName = dict["sportName"] as! String
        self.interestLevel = dict["interestLevel"] as! String
        self.skillLevel = dict["skillLevel"] as! String
    }
    
    var debugDescription: String {
        return "{sportName:\(sportName) interestLevel:\(interestLevel) skillLevel:\(skillLevel)}"
    }
}

struct BKKidModel: CustomDebugStringConvertible {
    
    /* {"gender":"boy",
     "school":"Free school",
     "id":87,
     "kidName":"The son of Stone",
     "sport":[{"interestLevel":"",
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
        return "kidname:\(kidName) id:\(id) age:\(age) gender:\(gender) school:\(school) sports:\(sports)"
    }
    
}







