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
    @objc dynamic var deviceId : String = ""
    @objc dynamic var deviceModel : String = ""
    @objc dynamic var deviceOS : String = ""
    override init(){
        super.init()
        let device = Common.currentDevice
        
        deviceId = device.identifierForVendor!.uuidString
        deviceModel = device.model
        deviceOS = "\(ProcessInfo().operatingSystemVersionString)"
    }
    
    required init(obj : [String:AnyObject]){
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
    
    func toInt64(_ obj: AnyObject!, defaultValue: Int64) -> Int64{
        if (obj == nil){
            return defaultValue
        }
        let value = Int64(String(describing: obj!))
        if (value == nil){
            return defaultValue
        }
        return value!
    }
    func toInt(_ obj: AnyObject!, defaultValue: Int) -> Int{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Int(String(describing: obj!)) as AnyObject, defaultValue: defaultValue as NSObject) as! Int
    }
    func toDouble(_ obj: AnyObject!, defaultValue: Double) -> Double{
        if (obj == nil){
            return defaultValue
        }
        return isNull(Double(String(describing: obj!)) as AnyObject, defaultValue: defaultValue as NSObject) as! Double
    }
    func toBool(_ obj: AnyObject!, defaultValue: Bool) -> Bool{
        if (obj == nil){
            return defaultValue
        }
        return (isNull(obj, defaultValue: defaultValue as NSObject) as! String).toBool(defaultValue)
    }
    func isNull(_ obj: AnyObject!, defaultValue: String) -> String{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return obj as! String
    }

    func isNull(_ obj: AnyObject!, defaultValue: NSObject) -> NSObject{
        if (obj == nil || obj is NSNull){
            return defaultValue
        }
        return obj as! NSObject
    }
    
    func toJsonObject() -> [String:AnyObject]
    {
        return [
            "version": self.version as AnyObject,
            "apiKey": self.apiKey as AnyObject,
            "deviceId": self.deviceId as AnyObject,
            "deviceModel": self.deviceModel as AnyObject,
            "deviceOS": self.deviceOS as AnyObject,
        ]
    }

    
    
}
