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
    var feedbackID      : NSNumber = 0
    var restroomId      : Int = 0
    var badge           : String! = ""
    var needAttention   : Bool = false
    var needCleaning    : Bool = false
    var needSupplies    : Bool = false
    var needRepair      : Bool = false
    var closed          : Bool = false
    var feedbackText    : String!
    var rating          : Double = 0.0
    var inspectionPassed: Bool?
    
    override init(){
        super.init()
    }
    init(restroomId: Int, inspectionPassed: Bool?, needCleaning: Bool, needSupplies: Bool, needRepair: Bool, closed: Bool, feedback: String, rating: Double, badge: String){
        super.init()
        self.restroomId         = restroomId
        self.inspectionPassed   = inspectionPassed
        self.needCleaning       = needCleaning
        self.needSupplies       = needSupplies
        self.needRepair         = needRepair
        self.needAttention      = needCleaning || needSupplies || needRepair
        self.closed             = closed
        self.feedbackText       = feedback
        self.rating             = rating
        self.badge              = badge
    }
    
    required init(obj : [String : AnyObject]){
        super.init(obj: obj)
        
        feedbackID          = NSNumber(value: toInt64(obj["feedbackId"], defaultValue: 0))
        restroomId          = toInt(obj["restroomId"], defaultValue: 0)
        badge               = isNull(obj["badge"], defaultValue: "")
        inspectionPassed    =  toNullableBool(obj["inspectionPassed"],defaultValue: nil)
        needCleaning        = Bool(truncating: toInt(obj["needCleaning"], defaultValue: 0) as NSNumber)
        needSupplies        = Bool(truncating: toInt(obj["needSupply"], defaultValue: 0) as NSNumber)
        needRepair          = Bool(truncating: toInt(obj["needRepair"], defaultValue: 0) as NSNumber)
        needAttention       = Bool(truncating: toInt(obj["needAttention"], defaultValue: 0) as NSNumber)
        closed              = Bool(truncating: toInt(obj["closed"], defaultValue: 0) as NSNumber)
        feedbackText        = isNull(obj["feedbackText"], defaultValue: "")
        rating              = toDouble(obj["rating"], defaultValue: 0)
        
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["feedbackId"]       = self.feedbackID
        obj["restroomId"]       = self.restroomId as AnyObject
        obj["badge"]            = self.badge as AnyObject
        obj["inspectionPassed"] = self.inspectionPassed as AnyObject
        obj["needCleaning"]     = self.needCleaning as AnyObject
        obj["needSupply"]       = self.needSupplies as AnyObject
        obj["needRepair"]       = self.needRepair as AnyObject
        obj["needAttention"]    = self.needAttention as AnyObject
        obj["closed"]           = self.closed as AnyObject
        obj["feedbackText"]     = self.feedbackText as AnyObject
        obj["rating"]           = self.rating as AnyObject
        return obj as AnyObject
    }
    
    
    
}

