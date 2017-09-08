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
let BKNetowrkBaseUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com"
let BKNetworkingLoginUrlStr = "\(BKNetowrkBaseUrlStr)/rest/login/dologin"
let BKNetworkingSignupUrlStr = "\(BKNetowrkBaseUrlStr)/rest/register/doregister"
let BKNetworkingAddKidUrlStr = "\(BKNetowrkBaseUrlStr)/rest/kid/addkid"

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
let BKGenderCellID = "BKGenderCellID"
let BKSportCellID = "BKSportCellID"
let BKAddKidCellID = "BKAddKidCellID"
let BKKidCellID = "BKKidCellID"
let BKKidActionCellID = "BKKidActionCellID"
let BKKidDoubleActionCellID = "BKKidDoubleActionCellID"
let BKEventDoubleActionCellID = "BKEventDoubleActionCellID"

let BKStartDateCellID =  "BKStartDateCellID"
let BKEndDateCellID =  "BKEndDateCellID"
let BKLocationCellID =  "BKLocationCellID"
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
let BKImageEditBtnIcon = "edit-btn-icon"
let BKImageScheduleBtnIcon = "schedule-btn-icon"

// Connection request decision
let BKConnectAcceptRespone = "Accept"
let BKConnectDeclineRespone = "Decline"

//All seques
let BKConnectPlayerCellSeque = "BKConnectPlayerCellSeque"

//Model data
let BKBloomSports = ["All", "Tennis", "Chess", "Basketball", "Baseball", "Cricket", "Soccer" ]
var BKSportLevels = ["Rookie", "Shining Star", "Rock Star"]


