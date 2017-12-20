//
//  RestStop.swift
//  Restroom
//
//  Created by DevTeam on 12/22/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
class RestStopModel: BaseModel{
    @objc dynamic var id : Int = 0
    var latitude : Double=0
    var longtitude : Double=0
    
    @objc dynamic var actRoute : String = ""
    @objc dynamic var address : String!
    @objc dynamic var city : String!
    @objc dynamic var country : String!
    @objc dynamic var drinkingWater : Bool=false
    @objc dynamic var note : String!
    @objc dynamic var hours : String!
    @objc dynamic var name : String = ""
    @objc dynamic var restType : String!
    @objc dynamic var isPaid : Bool = false
    
    @objc dynamic var state : String = ""
    @objc dynamic var zip : String = ""
    var averageRating : Double = 0
    var distanceFromLocation: Double = -1
    
    //required init(obj : NSDictionary){
    required init(obj:[String:AnyObject]){
        super.init(obj: obj)
        
        id = toInt(obj["restroomId"], defaultValue: 0)
        latitude = toDouble(obj["latDec"], defaultValue: 0)
        longtitude = toDouble(obj["longDec"], defaultValue: 0)
        name = isNull(obj["restroomName"], defaultValue: "")
        restType = isNull(obj["restroomType"], defaultValue: "") 
        state = isNull(obj["state"], defaultValue: "")
        zip = String(toInt64(obj["zip"],defaultValue: 0))
        averageRating = toDouble(obj["averageRating"], defaultValue: 0)
        drinkingWater = (isNull(obj["drinkingWater"], defaultValue: "n") ).toBool(false)
        hours = isNull(obj["hours"], defaultValue: "")
        note = isNull(obj["note"], defaultValue: "")
        
        actRoute = isNull(obj["actRoute"], defaultValue: "")
        address = isNull(obj["address"], defaultValue: "")
        city = isNull(obj["city"], defaultValue: "")
        country = isNull(obj["country"], defaultValue: "")
        isPaid = Bool(truncating: toInt(obj["isPaid"], defaultValue: 0) as NSNumber)
    }
}
