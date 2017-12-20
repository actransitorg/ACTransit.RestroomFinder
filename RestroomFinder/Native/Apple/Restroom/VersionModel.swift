//
//  VersionModel.swift
//  Restroom
//
//  Created by DevTeam on 7/7/16.
//  Copyright © 2016 Aidin. All rights reserved.
//

import Foundation
import SharedFramework
class VersionModel: BaseModel
{
    var appVersion : VersionHelper!
    var date : DateTime?
    var url = ""
    var applicationType = ""
    var fileName = ""
    

    required init(obj : [String:AnyObject]){
        super.init(obj: obj)
        appVersion = VersionHelper(version: isNull(obj["version"], defaultValue: Constants.defaultVersion) )
        internalDate = isNull(obj["date"], defaultValue: "") 
        url = isNull(obj["url"], defaultValue: "") 
        applicationType = isNull(obj["applicationType"], defaultValue: "") 
        fileName = isNull(obj["fileName"], defaultValue: "") 
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["version"] = self.appVersion
        obj["date"] = internalDate as AnyObject
        obj["url"] = self.url as AnyObject
        obj["applicationType"] = self.applicationType as AnyObject
        obj["fileName"] = self.fileName as AnyObject
        return obj as AnyObject
    }
    
    var internalDate : String {
        set{
            if let v=DateTime.parse(newValue) {
                date=v
            }
            date=DateTime.now()
        }
        get{
            if (date != nil){
                return date!.toString()
            }
            return ""
        }
    }
    
}
