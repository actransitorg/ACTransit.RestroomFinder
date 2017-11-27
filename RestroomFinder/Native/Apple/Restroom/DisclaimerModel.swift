//
//  DisclaimerModel.swift
//  Restroom
//
//  Created by DevTeam on 5/10/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class DisclaimerModel: BaseModel
{
    var badge : String = ""
    
    override init(){
        super.init()
    }
    init(badge: String){
        super.init()
        self.badge = badge
    }
    
    required init(obj : NSDictionary){
        super.init(obj: obj)
        badge = isNull(obj["badge"], defaultValue: "") as! String
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["badge"] = self.badge
        return obj as AnyObject
    }

}