//
//  Constants.swift
//  Restroom
//
//  Created by DevTeam on 5/5/16.
//  Copyright © 2016 DevTeam. All rights reserved.

//

import Foundation

struct Constants{
    static var appleId = 1423855730
    static var defaultVersion = "00.00.00"
    internal static var version : VersionHelper = VersionHelper(version: (Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as AnyObject).debugDescription!)
    static let apiKey : String = ""
    #if TEST
    static let flavor      :String="!!!TEST!!!"
    #elseif DEMO
    static let flavor      :String="!!!DEMO!!!"
    #elseif DEBUG
    static let flavor      :String="!!!DEBUG!!!"
    #else
    //static let flavor      :String="!Demo!"
    //static let flavor      :String="!Test!"
    static let flavor      :String="!Release!"
    #endif
    
    struct Server {
        static let baseDevURL      :String="https://devyour.company.domain/path/to/prod-restroom-finder-api/"
        static let baseDemoURL      :String="https://demoyour.company.domain/path/to/prod-restroom-finder-api/"
        static let baseTestURL      :String="https://your.company.domain/path/to/test-restroom-finder-api/"
        static let baseProdURL      :String="https://your.company.domain/path/to/prod-restroom-finder-api/"
        
        #if TEST
        static let baseURL      :String = baseTestURL
        #elseif DEMO
        static let baseURL      :String=baseDemoURL
        #elseif DEBUG
        //static let baseURL      :String=baseDevURL
        //static let baseURL      :String=baseDemoURL
        static let baseURL      :String=baseTestURL
        //static let baseURL       :String=baseProdURL
        #else
        //static let baseURL      :String=baseTestURL
        //static let baseURL      :String=baseDemoURL
        static let baseURL      :String=baseProdURL
        #endif
        
        
        static let baseRestroomURL      :String="\(Constants.Server.baseURL)restroomfinder2/api/"
        static let transitApiUrl        :String="\(Constants.Server.baseProdURL)transit"
        
        //static let baseURL            :String = "http://10.1.9.71/Restroom-Finder/api/";
        static let restroomUrl          :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/get"
        static let actRestroomUrl       :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/getActRestrooms"
        static let actNewPendingRestroomUrl       :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/getNewPendingActRestrooms"
        static let restroombyIdUrl       :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/getbyid"
        static let saveRestroomUrl      :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/post"
        static let saveActRestroomUrl   :String = "\(Constants.Server.baseRestroomURL)v2/Restrooms/postActRestroom"
        static let operationUrl         : String = "\(Constants.Server.baseRestroomURL)v2/Operator"
        static let sendSecurityCodeUrl  : String = "\(Constants.Server.baseRestroomURL)v2/Authentication/send"
        static let validateSecurityCodeUrl : String = "\(Constants.Server.baseRestroomURL)v2/Authentication/validateSecurityCode"
        static let authenticateUrl      : String = "\(Constants.Server.baseRestroomURL)v2/Authentication/authenticate"
        
        static let feedbackUrl          : String = "\(Constants.Server.baseRestroomURL)v2/Feedback"
        static let versionUrl           : String = "\(Constants.Server.baseRestroomURL)Version/iOS/Restroom";
        
        //NOTE: These were added to retrieve Trip Pattern
        
        static let transitApiToken:String="Enter demo transit API token here"
        
    }
    
    struct Messages {
        static let dailyDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision."
        
        static let onceDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination."
        
        static let drivingDisclaimerText = "It is a violation of California Vehicle Code ß23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. Please stop and turn off your vehicle before using this application."
        
        static let noGPSReception = "Sorry there's no GPS reception in this location. Make sure you are outdoors."
        static let poorGPSReception = "Sorry, GPS reception is poor in this location. Make sure you are outdoors."
        
        static let locationDisabled = "Background Location Access Disabled"
        static let setLocationAccess = "In order to be notified about Restrooms near you, please open this app's settings and set location access to 'Always'."
        
        static let invalidFirstName = "Please enter a valid first name."
        static let invalidLastName = "Please enter a valid last name."
        static let invalidBadge = "Please enter a valid badge."
        static let invalidPhone = "Please enter a valid phone number."
        static let invalidLogin = "Please provide the correct combination of First name, Last name and Badge no."
        static let invalidSecurityCode = "Please provide the correct combination of First name, Last name, Badge, Phone and Security code."
        
        static let newVersionAvaiable="A new version of the application is available. Would you like to update?"
        static let feedbackEmptySumbit="Please set rating or enter your feedback!"
        static let feedbackTextRequired="Please let us know your reasons for the rating."
        static let feedbackSumbitError="Error, please try again later."
        
        static let sessionApprovalNeeded = "Your account is pending approval. please try again later."
    }
    
    struct Variables {
        static let applicationDisableSpeed : Int = 3
        static let poorBestHorizontalAccuracy : Double = 163
        static let averageBestHorizontalAccuracy : Double = 40
        static let goodBestHorizontalAccuracy : Double = 15
        static let actionAlert_OK="OK"
        static let actionAlert_Cancel="Cancel"
        static let actionAlert_OpenSettings="Open Settings"
        static let hideSpeedIndicator = true
        //static let testMode = true
        #if TEST
        static let startupWaitTimeSec      :Int64=2
        #elseif DEMO
        static let startupWaitTimeSec      :Int64=2
        #elseif DEBUG
        static let startupWaitTimeSec      :Int64=1
        #else
        static let startupWaitTimeSec      :Int64=1
        #endif
    }
    
}

