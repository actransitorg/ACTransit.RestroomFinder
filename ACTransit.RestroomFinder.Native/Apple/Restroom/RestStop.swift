//
//  RestStop.swift
//  Restroom
//
//  Created by DevTeam on 12/22/15.
//  Copyright © 2015 DevTeam. All rights reserved.
//

import Foundation
import SharedFramework
import MapKit

class RestStopModel: BaseModel, Codable{
    @objc dynamic var id : Int = 0
    var latitude : Double=0
    var longitude : Double=0
    var isPaid : Bool = false
    var isNonPaid : Bool = false
    var isBart : Bool = false
    var isAct : Bool = false
    
    @objc dynamic var actRoute : String = ""
    @objc dynamic var address : String!
    @objc dynamic var city : String!
    @objc dynamic var country : String!
    @objc dynamic var note : String!
    @objc dynamic var nearestIntersection : String!
    @objc dynamic var weekdayHours : String!
    @objc dynamic var saturdayHours : String!
    @objc dynamic var sundayHours : String!
    @objc dynamic var name : String = ""
    @objc dynamic var serviceProvider : String!
    @objc dynamic var restType : String!
    @objc dynamic var contactName : String!
    @objc dynamic var contactTitle : String!
    @objc dynamic var contactPhone : String!
    @objc dynamic var contactEmail : String!
    @objc dynamic var state : String = ""
    @objc dynamic var zip : String = ""
    
    @objc dynamic var approved : Bool = false
    @objc dynamic var isPublic : Bool = false
    @objc dynamic var isHistory : Bool = false
    @objc dynamic var isToiletAvailable : Bool = true
    @objc dynamic var addressChanged : Bool = false
    @objc dynamic var toiletGenderId : Int = 0
    @objc dynamic var labelId : String = ""
    
    @objc dynamic var drinkingWater : Bool=false
    
    var averageRating : Double = 0
    var distanceFromLocation: Double = -1
    
    //required init(obj : NSDictionary){
    required init(obj:[String:AnyObject]){
        super.init(obj: obj)
        
        id = toInt(obj["restroomId"], defaultValue: 0)
        latitude = toDouble(obj["latDec"], defaultValue: 0)
        longitude = toDouble(obj["longDec"], defaultValue: 0)
        actRoute = isNull(obj["actRoute"], defaultValue: "")
        address = isNull(obj["address"], defaultValue: "")
        city = isNull(obj["city"], defaultValue: "")
        country = isNull(obj["country"], defaultValue: "")
        note = isNull(obj["note"], defaultValue: "")
        nearestIntersection = isNull(obj["nearestIntersection"], defaultValue: "")
        weekdayHours = isNull(obj["weekdayHours"], defaultValue: "")
        saturdayHours = isNull(obj["saturdayHours"], defaultValue: "")
        sundayHours = isNull(obj["sundayHours"], defaultValue: "")
        name = isNull(obj["restroomName"], defaultValue: "")
        serviceProvider = isNull(obj["serviceProvider"], defaultValue: "")
        restType = isNull(obj["restroomType"], defaultValue: "")
        contactName = isNull(obj["contactName"], defaultValue: "")
        contactTitle = isNull(obj["contactTitle"], defaultValue: "")
        contactPhone = isNull(obj["contactPhone"], defaultValue: "")
        contactEmail = isNull(obj["contactEmail"], defaultValue: "")
        
        state = isNull(obj["state"], defaultValue: "")
        zip = String(toInt64(obj["zip"],defaultValue: 0))
        approved = Bool(truncating: toInt(obj["approved"], defaultValue: 0) as NSNumber)
        isPublic = Bool(truncating: toInt(obj["isPublic"], defaultValue: 0) as NSNumber)
        isHistory = Bool(truncating: toInt(obj["isHistory"], defaultValue: 0) as NSNumber)
        isToiletAvailable = Bool(truncating: toInt(obj["isToiletAvailable"], defaultValue: 1) as NSNumber)
        addressChanged = Bool(truncating: toInt(obj["addressChanged"], defaultValue: 1) as NSNumber)
        toiletGenderId = toInt(obj["toiletGenderId"], defaultValue: 0)
        labelId = isNull(obj["labelId"], defaultValue: "")
                
        drinkingWater = (isNull(obj["drinkingWater"], defaultValue: "n") ).toBool(false)
      
        averageRating = toDouble(obj["averageRating"], defaultValue: 0)
        
       
//        isPaid = Bool(truncating: toInt(obj["isPaid"], defaultValue: 0) as NSNumber)
//        isBart = Bool(truncating: toInt(obj["isBart"], defaultValue: 0) as NSNumber)
//        isAct = Bool(truncating: toInt(obj["isAct"], defaultValue: 0) as NSNumber)
                      
        isPaid = restType=="PAID" ? true : false
        isBart = restType=="BART" ? true : false
        isAct = restType=="ACT" ? true : false
        isNonPaid = restType=="NON-PAID" ? true : false
    }
    static func create(id:Int,latitude: Double, longitude:Double, name: String,
                       address: String,  state: String, zip : String, city: String, country: String,
                       note: String, weekdayHours:String, saturdayHours:String, sundayHours:String,
                       serviceProvider:String, contactName: String, contactTitle: String,
                       contactPhone: String, contactEmail: String, labelId: String,
                       addressChanged: Bool, toiletGenderId: Int,
                       hasWater:Bool, isPaid:Bool, isUnPaid:Bool, isBart:Bool, isAct:Bool
                       , approved: Bool, isToiletAvailable: Bool) -> RestStopModel{
        var obj = BaseModel.getJsonObject()
        
        obj["restroomId"] = id as AnyObject
        obj["latDec"] = latitude as AnyObject
        obj["longDec"] = longitude as AnyObject
        obj["actRoute"] = "" as AnyObject
        obj["address"] = address as AnyObject
        obj["city"] = city as AnyObject
        obj["country"] = "USA" as AnyObject
        obj["note"] = note as AnyObject
        //obj["nearestIntersection"] = nearestIntersection as AnyObject
        obj["weekdayHours"] = weekdayHours as AnyObject
        obj["saturdayHours"] = saturdayHours as AnyObject
        obj["sundayHours"] = sundayHours as AnyObject
        obj["restroomName"] = name as AnyObject
        obj["serviceProvider"] = serviceProvider as AnyObject
        obj["restroomType"] = (isBart ? "BART": (isPaid ? "PAID" : (isAct ? "ACT":"NON-PAID"))) as AnyObject
        obj["contactName"] = contactName as AnyObject
        obj["contactTitle"] = contactTitle as AnyObject
        obj["contactPhone"] = contactPhone as AnyObject
        obj["contactEmail"] = contactEmail as AnyObject
        
        obj["state"] = state as AnyObject
        obj["zip"] = zip as AnyObject
        obj["approved"] = (approved ? 1 : 0) as AnyObject
        //obj["isPublic"] = (isPublic ? 1 : 0) as AnyObject
        //obj["isHistory"] = (isHistory ? 1 : 0) as AnyObject
        obj["isToiletAvailable"] = (isToiletAvailable ? 1 : 0) as AnyObject
        obj["addressChanged"] = (addressChanged ? 1 : 0) as AnyObject
        obj["toiletGenderId"] = toiletGenderId as AnyObject
        obj["labelId"] = labelId as AnyObject
        obj["drinkingWater"] = (hasWater ? "y" : "n") as AnyObject
        obj["averageRating"] = 0 as AnyObject
            
//        obj["isPaid"] = (paid ? 1 : 0) as AnyObject
//        obj["isBart"] = (bart ? 1 : 0) as AnyObject
//        obj["isAct"] = (act ? 1 : 0) as AnyObject
        
        
        
        return RestStopModel(obj: obj)
    }
    
    func toJsonObject() -> AnyObject{
        var obj = super.toJsonObject()
        obj["restroomId"] = id as AnyObject
        obj["latDec"] = latitude as AnyObject
        obj["longDec"] = longitude as AnyObject
        obj["actRoute"] = actRoute as AnyObject
        obj["address"] = address as AnyObject
        obj["city"] = city as AnyObject
        obj["country"] = country as AnyObject
        obj["note"] = note as AnyObject
        obj["weekdayHours"] = weekdayHours as AnyObject
        obj["saturdayHours"] = saturdayHours as AnyObject
        obj["sundayHours"] = sundayHours as AnyObject
        obj["restroomName"] = name as AnyObject
        obj["serviceProvider"] = serviceProvider as AnyObject
        obj["restroomType"] = restType as AnyObject
        obj["contactName"] = contactName as AnyObject
        obj["contactTitle"] = contactTitle as AnyObject
        obj["contactPhone"] = contactPhone as AnyObject
        obj["contactEmail"] = contactEmail as AnyObject
        
        obj["state"] = state as AnyObject
        obj["zip"] = zip as AnyObject
        obj["approved"] = (approved ? 1 : 0) as AnyObject
        obj["isPublic"] = (isPublic ? 1 : 0) as AnyObject
        obj["isHistory"] = (isHistory ? 1 : 0) as AnyObject
        obj["isToiletAvailable"] = (isToiletAvailable ? 1 : 0) as AnyObject
        obj["addressChanged"] = (addressChanged ? 1 : 0) as AnyObject
        obj["toiletGenderId"] = toiletGenderId as AnyObject
        obj["labelId"] = labelId as AnyObject
        obj["averageRating"] = averageRating as AnyObject
        obj["drinkingWater"] = (drinkingWater ? "Y" : "N") as AnyObject
              
//        obj["isPaid"] = (isPaid ? 1 : 0) as AnyObject
//        obj["isBart"] = (isBart ? 1 : 0) as AnyObject
        
        return obj as AnyObject
    }
    
    var location: CLLocation {
        get{
            return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
    }
}

