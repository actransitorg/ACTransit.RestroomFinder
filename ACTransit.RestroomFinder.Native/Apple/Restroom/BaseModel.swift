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
    @objc dynamic var deviceGuid : String = ""
    @objc dynamic var deviceModel : String = ""
    @objc dynamic var deviceOS : String = ""
    override init(){
        super.init()
        let device = Common.currentDevice
        
        deviceGuid = device.identifierForVendor!.uuidString
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
    
    
    
    func toJsonObject() -> [String:AnyObject]
    {
        return [
            "version": self.version as AnyObject,
            "apiKey": self.apiKey as AnyObject,
            "deviceGuid": self.deviceGuid as AnyObject,
            "deviceModel": self.deviceModel as AnyObject,
            "deviceOS": self.deviceOS as AnyObject,
        ]
    }

    static func getJsonObject() -> [String:AnyObject]
    {
        return [
            "version": "" as AnyObject,
            "apiKey": "" as AnyObject,
            "deviceGuid": "" as AnyObject,
            "deviceModel": "" as AnyObject,
            "deviceOS": "" as AnyObject,
        ]
    }
    
    
}
