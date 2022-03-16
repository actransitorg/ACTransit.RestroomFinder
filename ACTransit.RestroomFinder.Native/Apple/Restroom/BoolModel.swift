//
//  OperationModel.swift
//  Restroom
//
//  Created by DevTeam on 12/22/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class BoolModel: BaseModel{
    var value : Bool = false
    
    override init() {
        super.init()
    }
    required init(obj : [String: AnyObject]){
        super.init(obj: obj)
        
        self.value = Bool(truncating: toInt(obj["value"], defaultValue: 0) as NSNumber)
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["value"] = self.value as AnyObject;
        return obj as AnyObject
    }
    
}
