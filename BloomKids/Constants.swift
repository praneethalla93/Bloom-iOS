//
//  Constants.swift
//  BloomKids
//
//  Created by Andy Tong on 5/17/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

let BKGlobalTintColor = UIColor.init(red: 155/255.0, green: 207/255.0, blue: 132/255.0, alpha: 1.0)

let BKAlternativeColor = UIColor.init(red: 114/255.0, green: 202/255.0, blue: 204/255.0, alpha: 1.0)


let BKNavigationBarTitleFontSize: CGFloat = 17.0

let BKLoginLogoTopSpace: CGFloat = 20.0

let BKInputTextFieldHeight: CGFloat = UIScreen.main.bounds.size.height > 480.0 ? 35.0 : 30.0

let BKNetworkingLoginUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com/rest/login/dologin"

let BKNetworkingSignupUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com/rest/register/doregister"

let BKNetworkingAddKidUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com/rest/kid/addkid"
let BKNetworkingGetKidUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com/rest/kid/getkids"
let BKNetworkingLocationDetailsUrlStr = "http://custom-env.aqrfytx2is.us-east-1.elasticbeanstalk.com/rest/location/dolocationdetails"


let BKShouldGoToMain = "BKShouldGoToMain"

let BKKeychainService = "BKKeychainService"

let BKUserEmailKey = "BKUserEmailKey"
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
let BKSportLevelCellID = "BKSportLevelCellID"
let BKHasFinishedTutorial = "BKHasFinishedTutorial"
