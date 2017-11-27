//
//  OperationModel.swift
//  Restroom
//
//  Created by DevTeam on 12/22/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class OperationModel: BaseModel{
    dynamic var badge : String! = ""
    dynamic var incidentDateTime : String! = ""
    var agreed : Bool! = false
    var validating : Bool! = false
    
    override init() {
        super.init()
    }
    required init(obj : NSDictionary){
        super.init(obj: obj)

        self.badge = isNull(obj["badge"],defaultValue: "") as! String
        self.incidentDateTime = isNull(obj["incidentDateTime"],defaultValue: "") as! String
        self.agreed = Bool(toInt(obj["agreed"], defaultValue: 0))
        self.validating = Bool(toInt(obj["validating"], defaultValue: 0))
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["badge"] = self.badge;
        obj["incidentDateTime"] = self.incidentDateTime;
        obj["agreed"] = self.agreed;
        obj["validating"] = self.validating;
        return obj as AnyObject
    }
    
}