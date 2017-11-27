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
    

    required init(obj : NSDictionary){
        super.init(obj: obj)
        appVersion = VersionHelper(version: isNull(obj["version"], defaultValue: Constants.defaultVersion) as! String)
        internalDate = isNull(obj["date"], defaultValue: "") as! String
        url = isNull(obj["url"], defaultValue: "") as! String
        applicationType = isNull(obj["applicationType"], defaultValue: "") as! String
        fileName = isNull(obj["fileName"], defaultValue: "") as! String
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["version"] = self.appVersion
        obj["date"] = internalDate
        obj["url"] = self.url
        obj["applicationType"] = self.applicationType
        obj["fileName"] = self.fileName
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