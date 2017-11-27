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
    dynamic var id : Int = 0
    var latitude : Double=0
    var longtitude : Double=0
    
    dynamic var actRoute : String = ""
    dynamic var address : String!
    dynamic var city : String!
    dynamic var country : String!
    dynamic var drinkingWater : Bool=false
    dynamic var note : String!
    dynamic var hours : String!
    dynamic var name : String = ""
    dynamic var restType : String!
    dynamic var isPaid : Bool = false
    
    dynamic var state : String = ""
    dynamic var zip : String = ""
    var averageRating : Double = 0
    var distanceFromLocation: Double = -1
    
    required init(obj : NSDictionary){
        super.init(obj: obj)
        
        id = toInt(obj["restroomId"], defaultValue: 0)
        latitude = toDouble(obj["latDec"], defaultValue: 0)
        longtitude = toDouble(obj["longDec"], defaultValue: 0)
        name = isNull(obj["restroomName"], defaultValue: "") as! String
        restType = isNull(obj["restroomType"], defaultValue: "") as! String
        state = isNull(obj["state"], defaultValue: "") as! String
        zip = String(toInt64(obj["zip"],defaultValue: 0))
        averageRating = toDouble(obj["averageRating"], defaultValue: 0)
        drinkingWater = (isNull(obj["drinkingWater"], defaultValue: "n") as! String).toBool(false)
        hours = isNull(obj["hours"], defaultValue: "") as! String
        note = isNull(obj["note"], defaultValue: "") as! String
        
        actRoute = isNull(obj["actRoute"], defaultValue: "") as! String
        address = isNull(obj["address"], defaultValue: "") as! String
        city = isNull(obj["city"], defaultValue: "") as! String
        country = isNull(obj["country"], defaultValue: "") as! String
        isPaid = Bool(toInt(obj["isPaid"], defaultValue: 0))
    }
}