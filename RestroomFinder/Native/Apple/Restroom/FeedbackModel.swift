//
//  FeedbackModel.swift
//  Restroom
//
//  Created by DevTeam on 2/12/16.
//  Copyright © 2016 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class FeedbackModel: BaseModel{
    var feedbackID : NSNumber = 0
    var restStopID : Int = 0
    var badge : String! = ""
    var needAttention : Bool = false
    var feedbackText : String!
    var rate : Double = 0.0
    
    override init(){
        super.init()
    }
    init(restStopId: Int, needAttention: Bool, feedback: String, rate: Double, badge: String){
        super.init()
        self.restStopID = restStopId
        self.needAttention = needAttention
        self.feedbackText = feedback
        self.rate = rate
        self.badge = badge
    }
    
    required init(obj : [String : AnyObject]){
        super.init(obj: obj)
        
        feedbackID = NSNumber(value: toInt64(obj["feedbackId"], defaultValue: 0))
        restStopID = toInt(obj["restroomId"], defaultValue: 0)
        badge = isNull(obj["badge"], defaultValue: "") 
        needAttention = Bool(toInt(obj["needAttention"], defaultValue: 0) as NSNumber)
        feedbackText = isNull(obj["feedbackText"], defaultValue: "") 
        rate = toDouble(obj["rate"], defaultValue: 0)
        
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["feedbackId"] = self.feedbackID
        obj["restroomId"] = self.restStopID as AnyObject
        obj["badge"] = self.badge as AnyObject
        obj["needAttention"] = self.needAttention as AnyObject
        obj["feedbackText"] = self.feedbackText as AnyObject
        obj["rate"] = self.rate as AnyObject
        return obj as AnyObject
    }
    
    
    
}

