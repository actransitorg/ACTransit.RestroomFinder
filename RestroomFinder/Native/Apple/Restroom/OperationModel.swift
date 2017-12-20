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
    @objc dynamic var badge : String! = ""
    @objc dynamic var incidentDateTime : String! = ""
    var agreed : Bool! = false
    var validating : Bool! = false
    
    override init() {
        super.init()
    }
    required init(obj : [String: AnyObject]){
        super.init(obj: obj)

        self.badge = isNull(obj["badge"],defaultValue: "") 
        self.incidentDateTime = isNull(obj["incidentDateTime"],defaultValue: "") 
        self.agreed = Bool(truncating: toInt(obj["agreed"], defaultValue: 0) as NSNumber)
        self.validating = Bool(truncating: toInt(obj["validating"], defaultValue: 0) as NSNumber)
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["badge"] = self.badge as AnyObject;
        obj["incidentDateTime"] = self.incidentDateTime as AnyObject;
        obj["agreed"] = self.agreed as AnyObject;
        obj["validating"] = self.validating as AnyObject;
        return obj as AnyObject
    }
    
}
