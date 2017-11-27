//
//  BaseModel.swift
//  Restroom
//
//  Created by DevTeam on 5/10/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class BaseModel: SharedFramework.BaseModel{
    dynamic var deviceId : String = ""
    dynamic var deviceModel : String = ""
    dynamic var deviceOS : String = ""
    override init(){
        super.init()
        let device = Common.currentDevice
        
        deviceId = device.identifierForVendor!.UUIDString
        deviceModel = device.model
        deviceOS = "\(NSProcessInfo().operatingSystemVersionString)"
    }
    required init(obj : NSDictionary){
        super.init(obj: obj)
        
      
    }
    var version: String {
        get{
            return Constants.version.toString()
        }
    }
    var apiKey: String{
        get{
            return Constants.apiKey
        }
    }
    
    func toInt64(obj: AnyObject!, defaultValue: Int64) -> Int64{
        if (obj == nil){
            return defaultValue
        }
        let value = Int64(String(obj!))
        if (value == nil){
            return defaultValue
        }
        return value!
    }
    func toInt(obj: AnyObject!, defaultValue: Int) -> Int{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Int(String(obj!)), defaultValue: defaultValue) as! Int
    }
    func toDouble(obj: AnyObject!, defaultValue: Double) -> Double{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Double(String(obj!)), defaultValue: defaultValue) as! Double
    }
    func toBool(obj: AnyObject!, defaultValue: Bool) -> Bool{
        if (obj == nil){
            return defaultValue
        }
        return (isNull(obj, defaultValue: defaultValue) as! String).toBool(defaultValue)
    }
    func isNull(obj: AnyObject!, defaultValue: NSObject) -> NSObject{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return obj as! NSObject
    }
    
    func toJsonObject() -> [String:AnyObject]
    {
        return [
            "version": self.version,
            "apiKey": self.apiKey,
            "deviceId": self.deviceId,
            "deviceModel": self.deviceModel,
            "deviceOS": self.deviceOS,
        ]
    }

    
    
}