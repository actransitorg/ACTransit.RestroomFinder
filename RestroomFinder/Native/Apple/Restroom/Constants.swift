//
//  Constants.swift
//  Restroom
//
//  Created by DevTeam on 5/5/16.
//  Copyright Â© 2016 DevTeam. All rights reserved.

//

import Foundation

struct Constants{
    static var defaultVersion = "00.00.00"
    internal static var version : VersionHelper = VersionHelper(version: NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]!.debugDescription!)
    static let apiKey : String = ""

    struct Server {
        static let baseTestURL      :String="https://your.company.dns/path/to/restroom-finder-api/"
        static let baseURL      :String="https://your.company.dns/path/to/restroom-finder-api/"
        static let baseRestroomURL      :String="\(Constants.Variables.testMode ? Constants.Server.baseTestURL : Constants.Server.baseURL)restroom-finder/api/"
        
        static let restUrl      : String = "\(Constants.Server.baseRestroomURL)Restrooms"
        static let operationUrl : String = "\(Constants.Server.baseRestroomURL)Operator"
        static let versionUrl   : String = "\(Constants.Server.baseRestroomURL)Version/iOS/Restroom";
        
        //NOTE: These were added to retrieve Trip Pattern
        static let transitApiUrl:String="http://your.company.dns/path/to/transit-api"
        static let transitApiToken:String="Enter demo transit API token here"
        
    }
    
    struct Messages {
        static let dailyDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision."
        
        static let onceDisclaimerText = "I acknowledge that it is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle.  I will not use this application unless my coach is parked and turned off. By using this application I certify my agreement with this provision and I further understand that violation of it may subject me to disciplinary action up to and including termination."
        
        static let drivingDisclaimerText = "It is a violation of California Vehicle Code ÃŸ23123 and Transportation Department Bulletin 01-15 to use a handheld wireless telephone or other electronic device while operating a District vehicle. Please stop and turn off your vehicle before using this application."
        
        static let noGPSReception = "Sorry there's no GPS reception in this location. Make sure you are outdoors."
        static let poorGPSReception = "Sorry, GPS reception is poor in this location. Make sure you are outdoors."
        
        static let locationDisabled = "Background Location Access Disabled"
        static let setLocationAccess = "In order to be notified about Restrooms near you, please open this app's settings and set location access to 'Always'."
        
        static let invalidBadge = "Please enter a valid badge."
        static let newVersionAvaiable="A new version of the application is available. Would you like to update?"
        static let feedbackEmptySumbit="Please set rate or enter your feedback!"
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
        static let testMode = false
    }
    
}

