//
//  BKKidModel.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation

enum BKKidConnectionSate: Int {
    case requestSent = 100
    case requestPending = 101
    case connected = 102
    case rejected = 103
}

enum BKEventConnectionSate: Int {
    case requestSent = 200
    case requestPending = 201
    case accepted = 202
    case declined = 203
}

struct BKProfile {
    let email: String
    let parentName: String
    let city: String
    let state: String
    let phone: String
    let relation: String?
    let dob: String
    var kids: [BKKidModel]
    
    init(email: String, dict: [String: Any], kids: [BKKidModel]) {
        self.email = email
        self.parentName = (dict["parentName"] as! String).capitalized
        self.city = (dict["city"] as! String)
        self.state = (dict["state"] as! String)
        self.phone = (dict["phone"] as! String)
        self.dob = (dict["dob"] as! String)
        self.relation = (dict["relation"] as? String)
        self.kids = kids
        
        /*
        let kidsDict = dict["kids"] as! [[String: Any]]
        
        
        
        for dict in kidsDict {
            
            let kid = BKKidModel(dict: dict)
            kids.append(kid)
        }
        */
        
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
        self.kidName = kidName.capitalized
        self.gender = gender
        self.school = school
        self.age = age
        self.sports = sports
        self.id = id
    }
    
    init(dict: [String: Any]) {
        self.kidName = (dict["kidName"] as! String).capitalized
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
    var sport: BKSport?
    
    init(kidName: String, gender: String, school: String, age: String, sport: BKSport, id: Int, connectionState: BKKidConnectionSate, date: String, city: String, ownerId: Int) {
        self.kidname = kidName.capitalized
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
        self.kidname = (dict["kidname"] as! String).capitalized
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
        
        self.sport? = BKSport(dict: ["sportName" : sportName!, "skillLevel": skillLevel!])
        
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
    
    init(connresponderKidId: Int, responseAcceptStatus: Bool, connectionRequestorKidId: Int, sport: BKSport?, city: String, kidName: String, connectionDate: String) {
        self.connresponderKidId = connresponderKidId
        self.responseAcceptStatus = responseAcceptStatus
        self.connectionRequestorKidId = connectionRequestorKidId
        self.city = city
        self.kidName = kidName.capitalized
        self.connectionDate = connectionDate
        self.sport = sport
    }
    
    init(dict: [String: Any]) {
        self.connresponderKidId = dict["connresponderkidid"] as! Int
        self.responseAcceptStatus = dict["connResponderacceptance"] as! Bool
        self.connectionRequestorKidId = dict["connectionrequestorkidid"] as! Int
        
        self.city = dict["city"] as! String
        
        self.kidName = (dict["kidname"] as! String).capitalized
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

struct BKKidActivitySchedule {
    
    let id: Int
    let kidName: String
    let date: String
    let time: String
    let gender: String
    let age: String
    let school: String
    let location: String
    let sportName: String
    var connectionStateDescription: String
    var btn1Hidden: Bool
    var btn2Hidden: Bool
    var actionLabelHidden: Bool

    var connectionState: Int {
        
        didSet {
            
            print( "New connection state is \(connectionState)")
            
            self.connectionStateDescription = "Expired"
            self.actionLabelHidden = false
            self.btn1Hidden = true
            self.btn2Hidden = true
            
            let eventDateTime = "\(self.date)T\(self.time)"
            
            if ( self.connectionState == BKEventConnectionSate.requestSent.rawValue || self.connectionState == BKEventConnectionSate.declined.rawValue ) {
                
                self.connectionStateDescription = "Pending"
                
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date
                formatter.dateFormat = "MM/dd/yy'T'HH:mm"
                
                if let eventDate = formatter.date(from: eventDateTime)  {
                    
                    print( "event date \(eventDate)")
                    
                    if ( eventDate < Date() ) {
                        self.connectionStateDescription = "Expired"
                    }
                    
                } else {
                    
                    formatter.dateFormat = "E, d MMM yyyy'T'h:mm a"
                    
                    if let newEventDate = formatter.date(from: eventDateTime) {
                        
                        print( "new event date \(newEventDate)")
                        
                        if ( newEventDate < Date() ) {
                            self.connectionStateDescription = "Expired"
                        }
                        
                    }
                    
                }
                
                
            }
            else if (self.connectionState == BKEventConnectionSate.declined.rawValue ) {
                self.connectionStateDescription = "Declined"
            }
            else if (self.connectionState == BKEventConnectionSate.requestPending.rawValue ) {
                    
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date
                formatter.dateFormat = "MM/dd/yy'T'HH:mm"
                    
                if let eventDate = formatter.date(from: eventDateTime)  {
                        
                    print( "event date \(eventDate)")
                        
                    if ( eventDate > Date() ) {
                        self.connectionStateDescription = ""
                        self.actionLabelHidden = true
                        self.btn1Hidden = false
                        self.btn2Hidden = false
                    } else {
                        self.connectionStateDescription = "Expired"
                    }
                    
                } else {
                        
                    formatter.dateFormat = "E, d MMM yyyy'T'h:mm a"
                        
                    if let newEventDate = formatter.date(from: eventDateTime) {
                            
                        print( "new event date \(newEventDate)")
                            
                        if ( newEventDate > Date() ) {
                            self.connectionStateDescription = ""
                            self.actionLabelHidden = true
                            self.btn1Hidden = false
                            self.btn2Hidden = false
                        } else {
                            self.connectionStateDescription = "Expired"
                        }

                    }
                        
                }
               
            }
            else if ( self.connectionState == BKEventConnectionSate.accepted.rawValue ) {
                self.connectionStateDescription = "Accepted"
            }
            
        }

    }

    var convertedDate: Date {
        //formattedDate	String	"07/08/17 10:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy'T'HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = NSTimeZone.local
        
        let formattedDate = "\(date)T\(time)"
        
        if let convertedDate = dateFormatter.date(from: formattedDate) {
            print("formattedDate  \(formattedDate ) :: convertedDate \(convertedDate)")
            return convertedDate
            
        } else {
            dateFormatter.dateFormat = "E, d MMM yyyy'T'h:mm a"
            
            if let newconvertedDate =  dateFormatter.date(from: formattedDate) {
                print("formattedDate  \(formattedDate ) :: convertedDate \(newconvertedDate)")
                return newconvertedDate
            }

        }
        
        return Date()
        
    }
    
    init(id: Int, kidName: String, dateSchedule: String, timeSchedule: String, gender: String, age: String, school: String, location: String, sportName: String, connectionState: BKEventConnectionSate) {
        self.id = id
        self.kidName = kidName.capitalized
        self.date = dateSchedule
        self.time = timeSchedule
        self.gender = gender
        self.age = age
        self.school = school
        self.location = location
        self.sportName = sportName
        self.connectionState = connectionState.rawValue
        
        //to manage status for the tableviewcell
        self.connectionStateDescription = ""
        self.btn1Hidden = false
        self.btn2Hidden = false
        self.actionLabelHidden = false
    }
    
    init(dict: [String: Any]) {
        
        //to manage status for the tableviewcell
        self.connectionStateDescription = ""
        self.btn1Hidden = false
        self.btn2Hidden = false
        self.actionLabelHidden = false
        
        self.id = dict["id"] as! Int
        self.kidName = (dict["kidname"] as! String).capitalized
        
        
        self.date = dict["dateschedule"] as! String
        self.time = dict["timeschedule"] as! String
        self.gender = dict["gender"] as! String
        self.age = dict["age"] as! String
        self.school = dict["school"] as! String
        self.location = dict["location"] as! String
        self.sportName = dict["sportname"] as! String
        self.connectionState = Int(dict["scheduleconnectionstate"] as! String)!
    }
    
}

struct BKScheduleResponse {
    var responderKidId: Int
    var responderKidName: String
    var requesterKidId: Int
    var acceptanceStatus: Bool
    var requesterSkillLevel: Int
    var sportName: String
    var location: String
    var date: String
    var time: String

    init(responderKidId: Int,responderKidName: String, requesterKidId: Int, acceptanceStatus: Bool, requesterSkillLevel: Int, sportName: String, location: String, date: String, time: String) {
        
        
        self.responderKidId = responderKidId
        self.responderKidName = responderKidName
        self.requesterKidId = requesterKidId
        self.acceptanceStatus = acceptanceStatus
        self.requesterSkillLevel = requesterSkillLevel
        self.sportName = sportName
        self.location = location
        self.date = date
        self.time = time

    }
    
    init(dict: [String: Any]) {
        
        self.responderKidId = dict["scheduleresponderkidid"] as! Int
        self.responderKidName = dict["scheduleresponderkidname"] as! String
        self.requesterKidId = dict["schedulerequestorkidid"] as! Int
        self.acceptanceStatus = dict["scheduleresponderacceptance"] as! Bool
        self.requesterSkillLevel = dict["schedulerequestorskilllevel"] as! Int
        self.sportName = dict["schedulerequestorsportname"] as! String
        self.location = dict["schedulerequestorlocation"] as! String
        self.date = dict["schedulerequestordate"] as! String
        self.time = dict["schedulerequestortime"] as! String
    }
    
    /*
    var convertedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let formattedDate = "\(date)'T'\(time)"
        let convertedDate = dateFormatter.date(from: formattedDate)!
        print("convertedDate \(convertedDate)")
        return convertedDate
    }
    */


}







