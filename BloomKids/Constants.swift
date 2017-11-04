//
//  Constants.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

//let BKGlobalTintColor = UIColor.init(red: 155/255.0, green: 207/255.0, blue: 132/255.0, alpha: 1.0)
let BKGlobalTintColor = UIColor.init(red: 112/255.0, green: 202/255.0, blue: 204/255.0, alpha: 1.0)
let BKAlternativeColor = UIColor.init(red: 114/255.0, green: 202/255.0, blue: 204/255.0, alpha: 1.0)
let BKNavigationBarTitleFontSize: CGFloat = 17.0
let BKLoginLogoTopSpace: CGFloat = 20.0
let BKInputTextFieldHeight: CGFloat = UIScreen.main.bounds.size.height > 480.0 ? 35.0 : 30.0
let BKKidCellHeight: CGFloat = 100.0
let BKKidActionCellHeight: CGFloat = 150.0
let BKKidEventActionCellHeight: CGFloat = 170.0

//DEV URL
let BKNetowrkBaseUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com"

//PROD URL
//let BKNetowrkBaseUrlStr = "http://bloomkids-env.us-east-1.elasticbeanstalk.com"
let BKNetworkingLoginUrlStr = "\(BKNetowrkBaseUrlStr)/rest/login/dologin"
let BKNetworkingSignupUrlStr = "\(BKNetowrkBaseUrlStr)/rest/register/doregister"
let BKNetworkingAddKidUrlStr = "\(BKNetowrkBaseUrlStr)/rest/kid/addkid"
let BKNetworkingEditKidUrlStr = "\(BKNetowrkBaseUrlStr)/rest/kid/updatekid"

let BKNetworkingGetKidUrlStr = "\(BKNetowrkBaseUrlStr)/rest/kid/getkids"
let BKNetworkingGetKidsFilteredUrlStr = "\(BKNetowrkBaseUrlStr)/rest/kid/getkidsFiltered"
let BKNetworkingLocationDetailsUrlStr = "\(BKNetowrkBaseUrlStr)/rest/location/dolocationdetails"
let BKNetworkingActivityConnectionUrlStr = "\(BKNetowrkBaseUrlStr)/rest/connection/activityConnections"
let BKNetworkingConnectionsUrlStr = "\(BKNetowrkBaseUrlStr)/rest/connection/connections"
let BKNetworkingConnectionRequestorUrlStr = "\(BKNetowrkBaseUrlStr)/rest/connection/connectionRequestor"
let BKNetworkingConnectionResponderUrlStr = "\(BKNetowrkBaseUrlStr)/rest/connection/connectionResponder"
let BKNetworkingForgotPasswordUrlStr = "\(BKNetowrkBaseUrlStr)/rest/password/forgotpassword"
let BKNetworkingActivityScheduleUrlStr = "\(BKNetowrkBaseUrlStr)/rest/schedule/activitySchedules"
let BKNetworkingScheduleRequestorUrlStr = "\(BKNetowrkBaseUrlStr)/rest/schedule/scheduleRequestor"
let BKNetworkingScheduleResponderUrlStr = "\(BKNetowrkBaseUrlStr)/rest/schedule/scheduleResponder"
let BKGetFamilyDetailsUrlStr = "\(BKNetowrkBaseUrlStr)/rest/connection/family"

let BKShouldGoToMain = "BKShouldGoToMain"
let BKKeychainService = "BKKeychainService"
let BKUserEmailKey = "BKUserEmailKey"
let BKUserPasswordKey = "BKUserEmailKey"
let BKCurrentCity = "BKCurrentCity"
let BKCurrentState = "BKCurrentState"
let BKSportBtnToSportLevelVCSegue = "BKSportBtnToSportLevelVCSegue"
let BKPlaceResultCellID = "BKPlaceResultCellID"
let BKPlaceAutocompleteCountry: String? = "US"
let BKPhotoHeaderCellID = "BKPhotoHeaderCellID"
let BKSchoolSearchCellID = "BKSchoolSearchCellID"
let BKSimpleCellID = "BKSimpleCellID"
let BKSimpleSelectCellID = "BKSimpleSelectCellID"
let BKGenderCellID = "BKGenderCellID"
let BKSportCellID = "BKSportCellID"
let BKAddKidCellID = "BKAddKidCellID"
let BKKidCellID = "BKKidCellID"
let BKKidActionCellID = "BKKidActionCellID"
let BKKidDoubleActionCellID = "BKKidDoubleActionCellID"
let BKEventDoubleActionCellID = "BKEventDoubleActionCellID"
let BKEventDoubleActionNewCellID = "BKEventDoubleActionNewCellID"

let BKStartDateCellID =  "BKStartDateCellID"
let BKEndDateCellID =  "BKEndDateCellID"
let BKLocationCellID =  "BKLocationCellID"
let BKEventDatePickerCellID = "BKEventDatePickerCellID"
let BKEventSportCellID = "BKEventSportCellID"
let BKEventSportSelectCellID = "BKEventSportSelectCellID"
let BKScheduleButtonCellID = "BKScheduleButtonCellID"

let BKSportLevelCellID = "BKSportLevelCellID"
let BKHasFinishedOnboarding = "BKHasFinishedOnboarding"

//All connect screen CELLID
let BKConnectSummaryHeaderCellID = "BKConnectSummaryHeaderCell"
let BKConnectPlayerCellID = "BKConnectPlayerCell"
let BKConnectSectionHeaderCellID = "BKConnectSectionHeaderCell"

//All image assets
let BKImageConnectBtnIcon = "connect-btn-icon"
let BKImageConnectBtn = "connect-btn"
let BKImageEditBtnIcon = "edit-btn-icon"
let BKImageScheduleBtnIcon = "schedule-btn-icon"

// Connection request decision
let BKConnectAcceptRespone = "Accept"
let BKConnectDeclineRespone = "Decline"

//All seques
let BKConnectPlayerCellSeque = "BKConnectPlayerCellSeque"
let BKProfileSummaryHeaderCellID = "BKProfileSummaryHeaderCellID"

//Model data
//let BKBloomSports = ["All", "Tennis", "Chess", "Basketball", "Baseball", "Cricket", "Soccer" ]
let BKBloomSports = [BKAllSport, BKTennisSport, BKChessSport, BKBasketballSport, BKBaseballSport, BKCricketSport, BKSoccerSport]

let BKAllSport = "All"
let BKTennisSport = "Tennis"
let BKChessSport = "Chess"
let BKBasketballSport = "Basketball"
let BKBaseballSport = "Baseball"
let BKCricketSport = "Cricket"
let BKSoccerSport = "Soccer"


var BKSportLevels = ["Rookie", "Shining Star", "Rock Star"]

let BKGradeLevels = [BKPreK, BKKG, BK1stGrader, BK2ndGrader, BK3rdGrader, BK4thGrader, BK5thGrader, BK6thGrader, BK7thGrader, BK8thGrader]

let BKPreK = "Pre-K"
let BKKG = "KG"
let BK1stGrader = "1st Grader"
let BK2ndGrader = "2nd Grader"
let BK3rdGrader = "3rd Grader"
let BK4thGrader = "4th Grader"
let BK5thGrader = "5th Grader"
let BK6thGrader = "6th Grader"
let BK7thGrader = "7th Grader"
let BK8thGrader = "8th Grader"

let BKSportImageDict = [BKTennisSport: #imageLiteral(resourceName: "tennis-icon"), BKChessSport: #imageLiteral(resourceName: "chess-icon"), BKBasketballSport: #imageLiteral(resourceName: "basketball-icon"), BKBaseballSport: #imageLiteral(resourceName: "baseball-icon"), BKCricketSport: #imageLiteral(resourceName: "cricket-icon"), BKSoccerSport: #imageLiteral(resourceName: "soccer-icon")]

//user messages
let BKNoKidsRegistered = "No kids registered. Add your kid to get started."


