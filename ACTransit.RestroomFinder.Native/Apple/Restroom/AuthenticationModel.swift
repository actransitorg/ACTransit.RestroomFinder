//
//  OperationModel.swift
//  Restroom
//
//  Created by DevTeam on 12/22/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class AuthenticationModel: BaseModel{
    @objc dynamic var firstName : String! = ""
    @objc dynamic var lastName : String! = ""
    @objc dynamic var badge : String! = ""
    @objc dynamic var phoneNumber : String! = ""
    @objc dynamic var confirm2FACode : String! = ""
    @objc dynamic var incidentDateTime : String! = ""
    
    var agreed : Bool! = false
    var validating : Bool! = false
    var deviceSessionId : String?
   
    var sessionApproved : Bool = false
    var canAddRestroom : Bool = false
    var canEditRestroom : Bool = false
    
    override init() {
        super.init()
    }
    required init(obj : [String: AnyObject]){
        super.init(obj: obj)

        self.firstName = isNull(obj["firstName"],defaultValue: "")
        self.lastName = isNull(obj["lastName"],defaultValue: "")
        self.badge = isNull(obj["badge"],defaultValue: "")
        self.phoneNumber = isNull(obj["phoneNumber"],defaultValue: "")
        self.confirm2FACode = isNull(obj["confirm2FACode"],defaultValue: "")
        self.incidentDateTime = isNull(obj["incidentDateTime"],defaultValue: "") 
        self.agreed = Bool(truncating: toInt(obj["agreed"], defaultValue: 0) as NSNumber)
        self.validating = Bool(truncating: toInt(obj["validating"], defaultValue: 0) as NSNumber)
        self.deviceSessionId = isNull(obj["deviceSessionId"],defaultValue: "")
        self.sessionApproved = Bool(truncating: toInt(obj["sessionApproved"], defaultValue: 0) as NSNumber)
        self.canAddRestroom = Bool(truncating: toInt(obj["canAddRestroom"], defaultValue: 0) as NSNumber)
        self.canEditRestroom = Bool(truncating: toInt(obj["canEditRestroom"], defaultValue: 0) as NSNumber)
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["firstName"] = self.firstName as AnyObject;
        obj["lastName"] = self.lastName as AnyObject;
        obj["badge"] = self.badge as AnyObject;
        obj["phoneNumber"] = self.phoneNumber as AnyObject;
        obj["confirm2FACode"] = self.confirm2FACode as AnyObject;
        obj["incidentDateTime"] = self.incidentDateTime as AnyObject;
        obj["agreed"] = self.agreed as AnyObject;
        obj["validating"] = self.validating as AnyObject;
        obj["deviceSessionId"] = self.deviceSessionId as AnyObject;
        obj["sessionApproved"] = self.sessionApproved as AnyObject;
        obj["canAddRestroom"] = self.canAddRestroom as AnyObject;
        obj["canEditRestroom"] = self.canEditRestroom as AnyObject;
        return obj as AnyObject
    }
    
}
