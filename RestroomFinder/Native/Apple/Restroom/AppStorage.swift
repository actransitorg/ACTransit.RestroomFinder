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
    static let disclaimerPopupKey = "DisclaimerPopup_Agreed"
    
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

    static func setPopupDisclaimer(){
        var res = keyValues
        if (res == nil){
            res = [KeyValue]()
        }
        var keyvalue = res?.tryGetValue(disclaimerPopupKey)
        if (keyvalue == nil){
            keyvalue = KeyValue(key: disclaimerPopupKey, value: "set", updateDate: DateTime.now())
            res?.append(keyvalue!)
        }
        else {
            keyvalue?.updateDate = DateTime.now()
        }
        invalidateCache()
        KeyValue.Save(res!)
    }
    
    
    static func isFirstTimeRunningApplication() -> Bool{
        //return true
        if (keyValues == nil){
            return true
        }
        return false
    }
    
    static func setFirstTimeRunningApplication(badge: String) {
        var res = keyValues
        if (res == nil){
            res = [KeyValue]()
        }
        let keyvalue = res?.tryGetValue(disclaimerKey)
        if (keyvalue == nil){
            res?.append(KeyValue(key: disclaimerKey, value: badge, updateDate: DateTime.now())!)
        }
        else{
            keyvalue?.updateDate = DateTime.now()
            keyvalue?.value = badge
        }
        invalidateCache()
        KeyValue.Save(res!)
    }
    
    static var badge : String? {
        get{
            return keyValues?.tryGetValue(disclaimerKey)?.value
        }
    }


    
    private static var keyValues: [KeyValue]? {
        get{
            if (_keyValues == nil){
                _keyValues = KeyValue.Load()
            }
            return _keyValues
        }
    }
    private static func invalidateCache(){
        _keyValues = nil;
    }
}
