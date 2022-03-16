//
//  AppStorage.swift
//  Restroom
//
//  Created by DevTeam on 2/22/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class AppStorage{
    static let disclaimerKey = "Disclaimer_Agreed"
    static let badgeKey = "badge"
    static let phoneNumberKey = "phoneNumber"
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let disclaimerPopupKey = "DisclaimerPopup_Agreed"
    static let sessionKey = "SessionId"
    
    static var _keyValues: [KeyValue]!
    
    static func shouldPopupDisclaimer() -> Bool{
        let keyvalue = keyValues?.tryGetValue(disclaimerPopupKey)
        
        if (keyvalue == nil){
            return true
        }
        else {
            //print ("now: \(DateTime.now().toString()) vs \(keyvalue?.updateDate?.toString())")
            let now = DateTime.now()
            return (keyvalue?.updateDate?.year != now.year) ||
                    (keyvalue?.updateDate?.month != now.month) ||
                    (keyvalue?.updateDate?.day != now.day)
        }
    }

    static func setPopupDisclaimer() throws{
        try saveValue(key: disclaimerPopupKey, value: "set", dateTime: DateTime.now())
    }
    
    
    static func isEmpty() -> Bool{
        //return true
        if (keyValues == nil){
            return true
        }
        return false
    }
    
    static func setCurrentLoginInformation(_ firstName: String, lastName: String, badge: String, phoneNumber: String, sessionId: String) throws {
        
        try saveValue(key: badgeKey, value: badge, dateTime: DateTime.now())
        try saveValue(key: firstNameKey, value: firstName, dateTime: DateTime.now())
        try saveValue(key: lastNameKey, value: lastName, dateTime: DateTime.now())
        try saveValue(key: phoneNumberKey, value: phoneNumber, dateTime: DateTime.now())
        try saveValue(key: sessionKey, value: sessionId, dateTime: DateTime.now())
    }
    
    static func setDisclaimerShown() throws {
        try saveValue(key: disclaimerKey, value: "1", dateTime: DateTime.now())
    }
    
    
    static func saveValue(key:String, value:String?, dateTime:DateTime?) throws{
        var res = keyValues
        if (res == nil){
            res = [KeyValue]()
        }
        let keyvalue = res?.tryGetValue(key)
        if (keyvalue == nil){
            res?.append(KeyValue(key: key, value: value, updateDate: dateTime))
        }
        else{
            keyvalue?.updateDate = DateTime.now()
            keyvalue?.value = value
        }
        invalidateCache()
        _=KeyValue.Save(res!)
    }
    
    static func logOut() throws {
        try saveValue(key: disclaimerKey, value: "", dateTime: DateTime.now())
        try saveValue(key: badgeKey, value: "", dateTime: DateTime.now())
        try saveValue(key: firstNameKey, value: "", dateTime: DateTime.now())
        try saveValue(key: lastNameKey, value: "", dateTime: DateTime.now())
        try saveValue(key: phoneNumberKey, value: "", dateTime: DateTime.now())
        try saveValue(key: sessionKey, value: "", dateTime: DateTime.now())
        
        invalidateCache()
//        _=Common.NavigateToModal("Disclaimer", modalCompletion: { (controller) in
//        })
        
        let _=Common.NavigateTo("Login")
    }
    static var badge : String {
        get{
            return keyValues?.tryGetValue(badgeKey)?.value ?? ""
        }
    }
    static var phoneNumber : String {
        get{
            return keyValues?.tryGetValue(phoneNumberKey)?.value ?? ""
        }
    }
    static var firstName : String {
        get{
            return keyValues?.tryGetValue(firstNameKey)?.value ?? ""
        }
    }
    static var lastName : String {
        get{
            return keyValues?.tryGetValue(lastNameKey)?.value ?? ""
        }
    }
    static var sessionId : String {
        get{
            return keyValues?.tryGetValue(sessionKey)?.value ?? ""
        }
    }
    
    static var disclaimerShown: Bool {
        get{
            let value=keyValues?.tryGetValue(disclaimerKey)?.value
            return !(value==nil || value != "1")
        }
    }

    
    fileprivate static var keyValues: [KeyValue]? {
        get{
            if (_keyValues == nil){
                _keyValues = KeyValue.Load()
            }
            return _keyValues
        }
    }
    fileprivate static func invalidateCache(){
        _keyValues = nil;
    }
}
